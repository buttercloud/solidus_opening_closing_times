Spree::Store.class_eval do
  has_many :working_days

  def currently_open?
    todays_name = Date.today.strftime("%A")
    working_day = working_days.where(name: todays_name).first

    if working_day.present?
      working_day.currently_operating?
    else
      false
    end
  end

  def currently_closed?
    !currently_open?
  end

  def closest_working_date_and_time
    current_datetime = DateTime.now.utc
    current_datetime = current_datetime.change({ hour: 0, minute: 0, second: 0 })
    todays_name = current_datetime.strftime("%A")
    sorted_days_from_today = DateTime::DAYNAMES.rotate(DateTime::DAYNAMES.index(todays_name))

    if currently_open?
      return DateTime.now.utc
    else
      wds = working_days.includes(:working_hours)

      sorted_days_from_today.each do |day_name|
        wd = wds.find_by(name: day_name)

        if wd.present?

          while current_datetime.strftime("%A") != day_name do
            current_datetime = current_datetime.next_day;
          end

          while current_datetime.strftime("%A") == day_name do
            return current_datetime if wd.can_operate?(current_datetime)
            current_datetime += 15.minutes
          end
        end
      end
    end

    nil
  end
end
