class Spree::WorkingDay < ApplicationRecord
  belongs_to :store
  has_many :working_hours, dependent: :destroy
  validates :name, presence: true
  # ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  validates :name, inclusion: { in: Date::DAYNAMES, message: "Allowed names are #{Date::DAYNAMES}" }

  def currently_operating?
    can_operate?(DateTime.now.utc)
  end

  def can_operate?(datetime)
    hours_threshold = store.number_of_hours_allowed_before_placing_order ? store.number_of_hours_allowed_before_placing_order.hours : 0

    working_hours.each do |wh|
      wh_difference = wh.end_time - wh.start_time
      wh_start_time = wh.start_time.change(year: datetime.year, day: datetime.day, month: datetime.month)
      wh_end_time = wh_start_time + wh_difference

      if (datetime >= wh_start_time && datetime <= wh_end_time)
        if (datetime - hours_threshold + 1.minute >= DateTime.now.utc)
          return true
        end
      end
    end

    false
  end

  def description
    return "No working hours available" if working_hours.blank?
    working_hours.map{ |wh| "#{wh.start_time.to_s(:hour_minute_am_pm)} - #{wh.end_time.to_s(:hour_minute_am_pm)}"}.to_sentence
  end
end
