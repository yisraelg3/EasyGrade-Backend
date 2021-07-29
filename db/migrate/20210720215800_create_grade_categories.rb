class CreateGradeCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :grade_categories do |t|
      t.belongs_to :klass, null: false, foreign_key: true
      t.belongs_to :student,  foreign_key: true
      t.string :category
      t.string :student_grade
      t.date :year
      t.integer :semester
      t.text :comment

      t.timestamps
    end
  end
end
