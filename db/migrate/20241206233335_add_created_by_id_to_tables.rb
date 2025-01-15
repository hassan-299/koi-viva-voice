class AddCreatedByIdToTables < ActiveRecord::Migration[8.0]
  def change
    add_column :quizzes, :created_by_id, :integer
    add_column :questions, :created_by_id, :integer
    add_column :answers, :created_by_id, :integer
  end
end
