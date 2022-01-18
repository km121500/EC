class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :payjp_id,  null: false
      t.string :token_id,      null: false
      t.references :customer,        foreign_key: true
      t.timestamps
    end
  end
end
