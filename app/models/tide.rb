class Tide < ActiveRecord::Base
  validates_presence_of :day
  # after_create :add_to_calendar
  
  def self.import_tide_csv(csv_path)
    FasterCSV.foreach(csv_path) do |row|
      if (t = Tide.find :first, :conditions => ["day = ?", row[0]])
        #Need Update
        event_time = "#{row[0]} #{row[1]}".to_time
        case row[2]
          when /^[Ss]unrise.*/
            t.sunrise = event_time
          when /^[Ss]unset.*/
            t.sunset = event_time
          when /^[Hh]igh.*/
            if t.first_high.nil?
              t.first_high = event_time
            else
              t.second_high = event_time
            end
          when /^[Ll]ow.*/
            if t.first_low.nil?
              t.first_low = event_time
            else
              t.second_low = event_time
            end
          when /.*[Rr]ising$/
            if t.first_mark_rising.nil?
              t.first_mark_rising = event_time
            else
              t.second_mark_rising = event_time
            end
          when /.*[Ff]alling$/
            if t.first_mark_falling.nil?
              t.first_mark_falling = event_time
            else
              t.second_mark_falling = event_time
            end
        end
        t.save
      else
        # Create New
        event_time = "#{row[0]} #{row[1]}".to_time
        case row[2]
          when /^[Ss]unrise.*/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :sunrise => event_time
          when /^[Ss]unset.*/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :sunset => event_time
          when /^[Hh]igh.*/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :first_high => event_time
          when /^[Ll]ow.*/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :first_low => event_time
          when /.*[Rr]ising$/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :first_mark_rising => event_time
          when /.*[Ff]alling$/
            # puts "Creating -#{row[2]}- #{event_time}"
            t = Tide.create :day => row[0], :first_mark_falling => event_time
        end
      end
    end
  end
  
  def self.create_tide_csv(text_file_path)
    text_file = File.new(text_file_path,"r")
    csv_file = File.new("/tmp/#{rand(10000)}_#{Time.now.strftime("%H%M_%d-%m-%Y")}.csv","w")
    text_file.each do |line|
      parts = line.split(" ")
      date = parts[0]
      time = "#{parts[1]} #{parts[2]}"
      if parts.last.match(/^(S|s)un/)
        desc = parts.last
      else
        desc = parts.last(2).join(" ")
      end
      csv_file.write("#{date},#{time},#{desc}\n")
    end
    text_file.close
    csv_file.close
    return csv_file
  end
  
  def add_to_calendar
    load 'googlecalendar.rb'
    g = GoogleCalendar::GData.new
    g.login(GMAIL, GMAILPASSWD)
    # sunrise
    gcal_event = self.sunrise_event
    g.new_event(gcal_event, TIDECALENDARNAME)
    # sunset
    gcal_event = self.sunset_event
    g.new_event(gcal_event, TIDECALENDARNAME)
    # first rowing window
    gcal_event = self.first_rowing_window_event
    g.new_event(gcal_event, TIDECALENDARNAME) unless gcal_event.nil?
    # second rowing window
    gcal_event = self.second_rowing_window_event
    g.new_event(gcal_event, TIDECALENDARNAME) unless gcal_event.nil?
  end
  
  def self.today
    find :first, :conditions => { :day => Date.today }
  end

  def check_time(start, finish)
    messages = []
    messages << self.check_sunrise(start) 
    messages << self.check_sunset(finish)
    messages << "not enough water/light" unless self.in_either_tide_window(start, finish)
    messages << "finish time is before the start" if finish < start
    messages.compact
  end
  
  def tide_windows
    windows = []
    windows << self.first_rowing_window
    windows << self.second_rowing_window
  end

  protected
  def get_zulu_time(time)
    if time.strftime("%Y-%m-%d") == "2000-01-01"
      zero_day = Time.parse("2000-01-01")
      time_diff = time - zero_day
      time = self.day.beginning_of_day + time_diff - 3.hours #added because of heroku pacific coast thing
    end
    time.getutc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
  end
  
  def sunrise_event
    { :title=>'sunrise',
    :content=>'sunrise',
    :author=>'scheduler',
    :email=>GMAIL,
    :where=>self.location,
    :startTime=>get_zulu_time(self.sunrise),
    :endTime=>get_zulu_time(self.sunrise + 0.1.hour) }
  end
  
  def sunset_event
    { :title=>'sunset',
    :content=>'sunset',
    :author=>'scheduler',
    :email=>GMAIL,
    :where=>self.location,
    :startTime=>get_zulu_time(self.sunset),
    :endTime=>get_zulu_time(self.sunset + 0.1.hour) }
  end
  
  def first_rowing_window
    start = self.first_mark_rising
    finish = self.first_mark_falling
    finish = self.second_mark_falling if start > finish
    return nil if finish < (self.sunrise - self.light_allowance)
    return nil if start > (self.sunset)
    finish = self.sunset if (finish > self.sunset)
    start = (self.sunrise - self.light_allowance) if (start < (self.sunrise - self.light_allowance))
    return nil if start >= finish
    Hash["start" => start, "finish" => finish]
  end
  
  def second_rowing_window
    start = self.second_mark_rising
    finish = self.second_mark_falling
    finish = self.sunset if finish.nil?
    if start.nil? || (start > finish)
      start = (self.sunrise - self.light_allowance)
      finish = self.first_mark_falling
      return nil if (start > finish)
    end
    finish = self.sunset if start > finish
    return nil if finish < (self.sunrise - self.light_allowance)
    return nil if start > (self.sunset)
    finish = self.sunset if (finish > self.sunset)
    start = (self.sunrise - self.light_allowance) if (start < (self.sunrise - self.light_allowance))
    return nil if start >= finish
    Hash["start" => start, "finish" => finish]
  end
  
  def first_rowing_window_event
    window = self.first_rowing_window
    return nil if window.nil?
    return { :title=>'enough water',
    :content=>'enough water to row',
    :author=>'scheduler',
    :email=>GMAIL,
    :where=>self.location,
    :startTime=>get_zulu_time(window["start"]),
    :endTime=>get_zulu_time(window["finish"]) }
  end
  
  def second_rowing_window_event
    window = self.second_rowing_window
    return nil if window.nil?
    return { :title=>'enough water',
    :content=>'enough water to row',
    :author=>'scheduler',
    :email=>GMAIL,
    :where=>self.location,
    :startTime=>get_zulu_time(window["start"]),
    :endTime=>get_zulu_time(window["finish"]) }
  end
  
  def location
    "Cousins River, Yarmouth, ME"
  end
  
  def light_allowance
    0.25.hour
  end
  
  def check_sunrise(time)
    "time is before there is enough light" if time < (self.sunrise - self.light_allowance)
  end
  
  def check_sunset(time)
    "time is after dark" if time > (self.sunset)
  end
  
  def in_either_tide_window(start, finish)
    first = self.first_rowing_window
    second = self.second_rowing_window
    return self.in_tide_window(second, start, finish) if first.nil?
    return self.in_tide_window(first, start, finish) if second.nil?
    self.in_tide_window(first, start, finish) || self.in_tide_window(second, start, finish)
  end
  
  def in_tide_window(window, start, finish)
    return true if ((start >= window["start"]) && (finish <= window["finish"]))
    false
  end
end
