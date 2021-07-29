class CreateKlasses < ActiveRecord::Migration[6.1]
  def change
    create_table :klasses do |t|
      t.belongs_to :teacher, null: false, foreign_key: true
      t.string :subject
      t.string :grade
      t.boolean :locked

      t.timestamps
    end
  end
end
