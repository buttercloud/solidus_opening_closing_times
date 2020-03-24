class AddDescriptionToSpreeWorkingHour < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_working_hours, :description, :string
  end
end
