class AddStartedBooleanToQuizzes < ActiveRecord::Migration[8.0]
  def change
    add_column :quizzes, :started, :boolean, default: false, null: false
  end
end
