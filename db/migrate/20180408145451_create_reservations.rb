class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.integer :guest_id
      t.integer :restaurant_id
      t.integer :table_id
      t.integer :guest_number
      t.datetime :booking_time

      t.timestamps
    end
  end
end
