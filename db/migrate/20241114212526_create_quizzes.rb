class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.date :due_date, default: Date.today, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
