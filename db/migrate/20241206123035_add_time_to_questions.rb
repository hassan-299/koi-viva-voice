class AddTimeToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :duration, :integer
  end
end
