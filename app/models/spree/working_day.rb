class Spree::WorkingDay < ApplicationRecord
  belongs_to :store
  has_many :working_hours, dependent: :destroy
  validates :name, presence: true
  # ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  validates :name, inclusion: { in: Date::DAYNAMES, message: "Allowed names are #{Date::DAYNAMES}" }
  # default_scope { order(day_name_order) }

  def currently_operating?
    working_hours.each do |wh|
      return true if (Time.now.utc >= wh.start_time.utc && wh.end_time.utc <= Time.now.utc)
    end

    false
  end

  def description
    return "No working hours available" if working_hours.blank?
    working_hours.map{ |wh| "#{wh.start_time.to_s(:hour_minute_am_pm)} - #{wh.end_time.to_s(:hour_minute_am_pm)}"}.to_sentence
  end

  # def day_name_order
  #   "CASE day WHEN 'Sunday' THEN 0 " \
  #             "WHEN 'Monday' THEN 1 " \
  #             "WHEN 'Tuesday' THEN 2 " \
  #             "WHEN 'Wednesday' THEN 3 " \
  #             "WHEN 'Thursday' THEN 4 " \
  #             "WHEN 'Friday' THEN 5 " \
  #             "WHEN 'Saturday' THEN 6 END"
  # end
end
