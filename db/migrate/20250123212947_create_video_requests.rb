class CreateVideoRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :video_requests do |t|
      t.integer :student_id, null: false
      t.integer :question_id
      t.integer :quiz_id
      t.timestamps
    end
  end
end
