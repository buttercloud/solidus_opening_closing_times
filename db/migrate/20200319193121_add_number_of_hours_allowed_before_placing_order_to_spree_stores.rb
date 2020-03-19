class AddNumberOfHoursAllowedBeforePlacingOrderToSpreeStores < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_stores, :number_of_hours_allowed_before_placing_order, :float
  end
end
