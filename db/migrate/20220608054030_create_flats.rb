class CreateFlats < ActiveRecord::Migration[6.1]
  def change
    create_table :flats do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
