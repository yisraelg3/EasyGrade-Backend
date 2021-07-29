class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.belongs_to :parent, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :picture_url

      t.timestamps
    end
  end
end
