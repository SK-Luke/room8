class CreateChores < ActiveRecord::Migration[6.1]
  def change
    create_table :chores do |t|
      t.string :name
      t.string :frequency
      t.integer :repetition
      t.integer :duration
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
