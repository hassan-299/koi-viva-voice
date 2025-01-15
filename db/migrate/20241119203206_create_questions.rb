class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :description
      t.integer :quiz_id

      t.timestamps
    end
  end
end
