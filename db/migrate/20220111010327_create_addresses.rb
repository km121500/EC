class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :customer_id, nill:false
      t.string :name, nill:false
      t.string :address, nill:false
      t.string :postal_code, nill:false

      t.timestamps null: false
      
      t.timestamps
    end
  end
end
