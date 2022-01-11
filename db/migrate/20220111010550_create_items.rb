class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.integer :genre_id,  nill:false
      t.integer :price, null: false
      t.string :image_id, null: false
      t.boolean :is_status, null: false, default: true
      t.timestamps
    end
  end
end
