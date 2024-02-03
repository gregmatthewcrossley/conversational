class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.integer :altitude
      t.integer :heading
      t.references :conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
