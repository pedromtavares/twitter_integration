class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :salt, :null => false
      t.string :password_hash, :null => false
      t.string :access_token
      t.string :access_secret
      t.timestamps
    end

    add_index :users, [:email], :unique => true
  end

  def self.down
    drop_table :users
  end
end
