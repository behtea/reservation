class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :tables do |t|
      t.integer :restaurant_id
      t.string :name
      t.integer :minimum_guest
      t.integer :maximum_guest

      t.timestamps
    end
  end
end
