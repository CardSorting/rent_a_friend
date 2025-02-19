class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :friend, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :service_category, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, null: false, default: 'pending'
      t.integer :total_amount_cents, null: false, default: 0
      t.string :total_amount_currency, null: false, default: 'USD'
      t.text :notes

      t.timestamps
    end

    add_index :bookings, [:friend_id, :start_time]
    add_index :bookings, [:friend_id, :end_time]
    add_index :bookings, [:user_id, :status]
    add_index :bookings, :status

    # Add check constraints
    execute <<-SQL
      ALTER TABLE bookings
      ADD CONSTRAINT end_time_after_start_time
      CHECK (end_time > start_time)
    SQL

    execute <<-SQL
      ALTER TABLE bookings
      ADD CONSTRAINT valid_status
      CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled'))
    SQL
  end
end
