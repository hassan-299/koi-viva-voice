class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email
      t.string :password
      t.integer :role, default: 0
      t.integer :status, default: 0
      t.integer :failed_attempts, default: 0
      t.timestamps
    end
  end
end
