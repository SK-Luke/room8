class CreateChoreLists < ActiveRecord::Migration[6.1]
  def change
    create_table :chore_lists do |t|
      t.datetime :deadline
      t.boolean :complete, default: false
      t.references :month_list, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :chores, null: false, foreign_key: true

      t.timestamps
    end
  end
end
