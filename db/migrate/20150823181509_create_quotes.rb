class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :name
      t.string :quote_type
      t.string :type_of_home
      t.string :recurrence
      t.string :day_preference
      t.string :time_preference
      t.string :bedrooms
      t.string :bathrooms
      t.string :square_feet
      t.string :cleaning_supplies
      t.boolean :eco_friendly
      t.boolean :laundry
      t.boolean :pets
      t.boolean :refrigerator
      t.boolean :oven
      t.boolean :windows
      t.string :location
      t.string :request_time

      t.timestamps null: false
    end
  end
end
