class Student < ApplicationRecord
  belongs_to :parent
  has_many :grade_categories, dependent: :destroy
  has_many :klasses, through: :grade_categories
  has_many :teachers, through: :klasses

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true

  def create_grade_categories_from_array(class_id_array)
    # byebug
    class_id_array.map do |klass_id|
      # self.grade_categories.uniq{|category| category.category}.each do |grade_category| 
        self.grade_categories.create!(klass_id: klass_id, locked: false) 
      # end
    end
  end
  
  def destroy_grade_categories_from_array(class_id_array)
    class_id_array.each do |klass_id| 
      grade_category_to_delete = self.grade_categories.find_by!(klass_id: klass_id)
      grade_category_to_delete.destroy
    end
  end

  def admin_update_grades(grades_array, locked)
    grades_array.each do |grade|
      # byebug
      grade_category = self.grade_categories.find(grade[:id])
      grade_category.update(student_grade: grade[:student_grade], locked: locked)
    end
  end

  def teacher_update_grades(grades_array, locked)
    grades_array.each do |grade|
      # byebug
      grade_category = self.grade_categories.find(grade[:id])
      grade_category.update(student_grade: grade[:student_grade])
    end
  end
end
