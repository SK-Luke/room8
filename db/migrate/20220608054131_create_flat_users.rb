class CreateFlatUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :flat_users do |t|
      t.boolean :active, default: false
      t.references :user, null: false, foreign_key: true
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
