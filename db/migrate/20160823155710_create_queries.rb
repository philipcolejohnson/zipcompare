class CreateQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :queries do |t|
      t.string :zip1
      t.string :zip2

      t.timestamps
    end
  end
end
