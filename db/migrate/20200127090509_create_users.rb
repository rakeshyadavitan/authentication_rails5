class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest
      t.string :remember_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :confirmation_token
      t.string :unconfirmed_email
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token, unique: true
    add_index :users, :password_reset_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unconfirmed_email, unique: true
  end
end
