Spree::Store.class_eval do
  validate :opening_closing_times_and_days_structure
  validate :opening_closing_times_and_days_range
  validate :opening_closing_times_and_days_overlap

  serialize :opening_closing_times_and_days, JSON

  def opening_closing_times_and_days_overlap
    if opening_closing_times_and_days
      valid_condition = true

      valid_condition = opening_closing_times_and_days.all? do |_, times_objs|
        sorted = times_objs.sort_by do |obj|
          start_hour = obj["start_hour"].to_i
          start_min = obj["start_min"].to_i
          end_hour = obj["end_hour"].to_i
          end_min = obj["end_min"].to_i

          start_time = Time.parse("#{start_hour}:#{start_min}")

          start_time
        end

        condition = sorted.each_with_index.all? do |obj, idx|
          last = sorted.length == idx + 1

          if !last
            end_hour = obj["end_hour"].to_i
            end_min = obj["end_min"].to_i

            end_time_first_range = Time.parse("#{end_hour}:#{end_min}")

            start_hour_second_range = sorted[idx+1]["start_hour"].to_i
            start_min_second_range = sorted[idx+1]["start_min"].to_i

            start_time_first_range = Time.parse("#{start_hour_second_range}:#{start_min_second_range}")

            return end_time_first_range < start_time_first_range
          else
            return true
          end
        end

        condition
      end
    else
      valid_condition = true
    end

    if !valid_condition
      errors.add(:opening_closing_times_and_days, "overlap")
    end
  end

  def opening_closing_times_and_days_range
    if opening_closing_times_and_days
      valid_condition = true

      valid_condition = opening_closing_times_and_days.map do |_, times_objs|
        condition = times_objs.all? do |obj|
          start_hour = obj["start_hour"].to_i
          start_min = obj["start_min"].to_i
          end_hour = obj["end_hour"].to_i
          end_min = obj["end_min"].to_i

          start_time = Time.parse("#{start_hour}:#{start_min}")
          end_time = Time.parse("#{end_hour}:#{end_min}")

          start_time <= end_time
        end

        condition
      end.all?
    else
      valid_condition = true
    end

    if !valid_condition
      errors.add(:opening_closing_times_and_days, "end time is before start time")
    end
  end

  def opening_closing_times_and_days_structure
    if opening_closing_times_and_days
      days = Date::DAYNAMES.map(&:downcase).map(&:to_s)

      valid_structure = (opening_closing_times_and_days.keys & days).length > 0 &&
                        opening_closing_times_and_days.values.all? { |v| v.is_a?(Array) }

    else
      valid_structure = true
    end

    if !valid_structure
      errors.add(:opening_closing_times_and_days, "invalid structure")
    end
  end

  def currently_open?
    today = Date.today.strftime("%A").downcase
    now = Time.now

    if opening_closing_times_and_days
      objs = opening_closing_times_and_days[today]

      if objs
        objs.any? do |obj|
          start_hour = obj["start_hour"].to_i
          start_min = obj["start_min"].to_i
          end_hour = obj["end_hour"].to_i
          end_min = obj["end_min"].to_i

          start_time = Time.parse("#{start_hour}:#{start_min}")
          end_time = Time.parse("#{end_hour}:#{end_min}")

          (now >= start_time) && (now <= end_time)
        end
      else
        false
      end
    else
      true
    end
  end
end
  