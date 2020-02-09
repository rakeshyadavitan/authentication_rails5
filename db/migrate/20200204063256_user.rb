class User < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :encrypted_password 
      t.string :salt
      t.string :remember_token
      t.boolean :terms_of_service, default: false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token, unique: true
  end
end