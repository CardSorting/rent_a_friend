class CreateServiceCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :service_categories do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :service_categories, :name, unique: true
  end
end
