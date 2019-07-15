class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :role
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
