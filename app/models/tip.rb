class Tip < ActiveRecord::Base
  attr_accessible :content, :creator_id, :modifier_id, :path
  
  belongs_to :creator, :class_name => "User"
  belongs_to :modifier, :class_name => "User"
  
  validates :content, :presence => true
  validates :path, :presence => true, :uniqueness => true
  
  @@options_for_collection_select = Rails.application.routes.routes.map do |route|
                                      [route.path.spec.to_s.gsub(/\(\.\:format\)/,''), "#{route.defaults[:controller]} - #{route.defaults[:action]}"] unless ["create","update","destroy"].include?(route.defaults[:action])
                                    end.compact
  def self.available_options
    @@options_for_collection_select.sort { |a,b| a.first.downcase <=> b.first.downcase }
  end
  
  def self.actual_path_lookup(path)
    value = "unknown"
    @@options_for_collection_select.each do |option|
      if option.last == path
        value = option.first
        break
      end
    end
    value
  end
  
  def actual_path
    Tip.actual_path_lookup(self.path)
  end
end
