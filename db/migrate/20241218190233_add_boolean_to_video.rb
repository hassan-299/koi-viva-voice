class AddBooleanToVideo < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :is_published, :boolean, default: false, null: false
  end
end
