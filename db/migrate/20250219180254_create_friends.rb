class CreateFriends < ActiveRecord::Migration[8.0]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.text :bio, null: false
      t.integer :hourly_rate_cents, null: false, default: 0
      t.string :hourly_rate_currency, null: false, default: "USD"
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
