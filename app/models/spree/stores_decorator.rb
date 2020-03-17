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
end
  
