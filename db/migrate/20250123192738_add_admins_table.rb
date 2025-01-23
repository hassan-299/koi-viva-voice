class AddAdminsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password

      t.timestamps
    end

    Admin.find_or_create_by(username: 'admin', password: 'secret!')
    Organization.find_or_create_by(name: 'KOI VIVA Voce', subdomain: 'students.koi.edu.au')
  end
end
