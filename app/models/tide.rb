require "csv"

class Tide < ApplicationRecord
  validates :day, presence: true

  def self.import_tide_csv(csv_path, time_zone = "UTC")
    CSV.foreach(csv_path) do |row|
      # row[0]: day, row[1]: time, row[2]: description
      tide = find_or_initialize_by(day: row[0])
      event_time = Time.zone.parse("#{row[0]} #{row[1]}")

      case row[2]
      when /^[Ss]unrise.*/
        tide.sunrise = event_time
      when /^[Ss]unset.*/
        tide.sunset = event_time
      when /^[Hh]igh.*/
        if tide.first_high.nil?
          tide.first_high = event_time
        else
          tide.second_high = event_time
        end
      when /^[Ll]ow.*/
        if tide.first_low.nil?
          tide.first_low = event_time
        else
          tide.second_low = event_time
        end
      when /.*[Rr]ising$/
        if tide.first_mark_rising.nil?
          tide.first_mark_rising = event_time
        else
          tide.second_mark_rising = event_time
        end
      when /.*[Ff]alling$/
        if tide.first_mark_falling.nil?
          tide.first_mark_falling = event_time
        else
          tide.second_mark_falling = event_time
        end
      end
      tide.save
    end
    File.delete(csv_path) if File.exist?(csv_path)
  end

  def self.create_tide_csv(text_file_path)
    csv_filename = "#{Rails.root}/tmp/#{SecureRandom.hex(4)}_#{Time.now.strftime("%H%M_%d-%m-%Y")}.csv"
    CSV.open(csv_filename, "wb") do |csv|
      File.foreach(text_file_path) do |line|
        row = line.split(" ")
        # match legacy logic for AM/PM in row[2]
        if ["AM", "PM"].include?(row[2]&.upcase)
          desc = row.last
          if desc.include?("ising") || desc.include?("alling") || desc.include?("ide")
            desc = row.last(2).join(" ")
          end
          csv << [row[0], "#{row[1]} #{row[2]}", desc]
        end
      end
    end
    File.delete(text_file_path) if File.exist?(text_file_path)
    csv_filename
  end

  def self.today
    find_by(day: Date.today)
  end

  def check_time(start_time, finish_time)
    messages = []
    messages << "time is before there is enough light" if start_time < (sunrise - light_allowance)
    messages << "time is after dark" if finish_time > sunset
    messages << "not enough water/light" unless in_either_tide_window(start_time, finish_time)
    messages << "finish time is before the start" if finish_time < start_time
    messages.compact
  end

  def tide_windows
    [first_rowing_window, second_rowing_window].compact
  end

  def first_rowing_window
    start = first_mark_rising
    finish = first_mark_falling
    return nil unless start && finish

    finish = second_mark_falling if start > finish
    return nil if finish < (sunrise - light_allowance)
    return nil if start > sunset

    finish = sunset if finish > sunset
    start = (sunrise - light_allowance) if start < (sunrise - light_allowance)

    return nil if start >= finish
    {"start" => start, "finish" => finish}
  end

  def second_rowing_window
    start = second_mark_rising
    finish = second_mark_falling
    # Logic in legacy for second window was a bit complex/convoluted
    # Porting best attempt at matching behavior:
    finish ||= sunset
    if start.nil? || (start > finish)
      start = (sunrise - light_allowance)
      finish = first_mark_falling
    end

    return nil if start.nil? || finish.nil?
    finish = sunset if start > finish
    return nil if finish < (sunrise - light_allowance)
    return nil if start > sunset

    finish = sunset if finish > sunset
    start = (sunrise - light_allowance) if start < (sunrise - light_allowance)

    return nil if start >= finish
    {"start" => start, "finish" => finish}
  end

  private

  def light_allowance
    15.minutes
  end

  def in_either_tide_window(start_time, finish_time)
    [first_rowing_window, second_rowing_window].compact.any? do |window|
      start_time >= window["start"] && finish_time <= window["finish"]
    end
  end
end
