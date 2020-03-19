class Spree::WorkingDay < ApplicationRecord
  belongs_to :store
  has_many :working_hours, dependent: :destroy
  validates :name, presence: true
  # ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  validates :name, inclusion: { in: Date::DAYNAMES, message: "Allowed names are #{Date::DAYNAMES}" }

  def currently_operating?
    can_operate?(DateTime.now)
  end

  def can_operate?(datetime)
    time = datetime.utc.strftime('%H:%M')

    working_hours.each do |wh|
      wh_start_time = wh.start_time.utc.strftime('%H:%M')
      wh_end_time = wh.end_time.utc.strftime('%H:%M')
      # compare time only regardless of date.
      return true if (time >= wh_start_time && time <= wh_end_time)
    end

    false
  end

  def description
    return "No working hours available" if working_hours.blank?
    working_hours.map{ |wh| "#{wh.start_time.to_s(:hour_minute_am_pm)} - #{wh.end_time.to_s(:hour_minute_am_pm)}"}.to_sentence
  end
end
