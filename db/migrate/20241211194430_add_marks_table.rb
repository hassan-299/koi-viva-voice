class AddMarksTable < ActiveRecord::Migration[8.0]
  def change
    create_table :marks do |t|
      t.integer :teacher_id
      t.integer :answer_id
      t.integer :number
      t.text :comment

      t.timestamps
    end
  end
end
