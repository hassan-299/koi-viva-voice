class AddFieldsToTables < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :student_id, :integer
    add_column :videos, :student_id, :integer
    add_column :videos, :question_id, :integer
  end
end
