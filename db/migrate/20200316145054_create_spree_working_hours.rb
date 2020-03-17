class CreateSpreeWorkingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_working_hours do |t|
      t.time :start_time
      t.time :end_time
      t.integer :working_day_id
      t.timestamps
    end
  end
end
