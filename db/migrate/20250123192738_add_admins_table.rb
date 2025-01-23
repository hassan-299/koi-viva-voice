class AddAdminsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password

      t.timestamps
    end

    Admin.create(username: 'admin', password: 'secret!')
  end
end
