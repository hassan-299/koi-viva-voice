class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.integer :user_id, null: false
      t.integer :quiz_id, null: false
      t.integer :status, default: 2, null: false

      t.timestamps
    end
  end
end
