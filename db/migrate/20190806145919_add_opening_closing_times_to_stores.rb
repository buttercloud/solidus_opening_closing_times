class AddOpeningClosingTimesToStores < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_stores, :opening_closing_times_and_days, :text
  end
end
