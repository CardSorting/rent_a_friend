class CreateTimeSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :time_slots do |t|
      t.references :friend, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :available, null: false, default: true

      t.timestamps
    end

    add_index :time_slots, [:friend_id, :start_time]
    add_index :time_slots, [:friend_id, :end_time]
    add_index :time_slots, :available

    # Add a check constraint to ensure end_time is after start_time
    execute <<-SQL
      ALTER TABLE time_slots
      ADD CONSTRAINT end_time_after_start_time
      CHECK (end_time > start_time)
    SQL
  end
end
