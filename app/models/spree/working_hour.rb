class Spree::WorkingHour < Spree::Base
  belongs_to :working_day
  validates :start_time, :end_time, presence: true
  validate :validate_interval
  default_scope { order(start_time: :asc, end_time: :asc) }

  def validate_interval
    if end_time.present? && start_time.present?
      errors.add(:base, "End time should be greater than start time") if end_time <= start_time
    else
      errors.add(:base, "End & start time should be present")
    end
  end
end
