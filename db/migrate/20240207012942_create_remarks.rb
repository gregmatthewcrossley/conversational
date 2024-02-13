class CreateRemarks < ActiveRecord::Migration[7.1]
  def change
    create_table :remarks do |t|
      t.string :speaker_class, null: false
      t.text :content, null: false
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
