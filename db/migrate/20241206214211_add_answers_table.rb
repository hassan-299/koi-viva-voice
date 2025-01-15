class AddAnswersTable < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string :answer
      t.integer :video_id

      t.timestamps
    end
  end
end
