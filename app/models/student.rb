class Student < ApplicationRecord
  belongs_to :parent
  has_many :grade_categories, dependent: :destroy
  has_many :klasses, through: :grade_categories
  has_many :teachers, through: :klasses

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true

  def create_grade_categories_from_array(class_id_array, year)
    # byebug
    class_id_array.map do |klass_id|
      # self.grade_categories.uniq{|category| category.category}.each do |grade_category| 
        self.grade_categories.create!(klass_id: klass_id, locked: false, year: year, semester: 1) 
      # end
    end
  end
  
  def destroy_grade_categories_from_array(class_id_array, year)
    class_id_array.each do |klass_id| 
      # byebug
      grade_category_to_delete = self.grade_categories.where(klass_id: klass_id, year: year)
      grade_category_to_delete.destroy_all
    end
  end

  def admin_update_grades(grades_array, locked, year)
    grades_array.each do |grade|
      semesters = grade.keys.filter{|key| key != "subject" && key != "key"}
      semesters.each do |semester|
        # byebug
        grade_category = self.grade_categories.find_by(klass_id: grade[:key], semester: semester, year: year)
        if grade_category
          grade_category.update(student_grade: grade[semester], locked: locked)
        else
          self.grade_categories.create!(klass_id: grade[:key], semester: semester, student_grade: grade[semester], locked: locked, year: year)
        end
      end
    end
  end

  def teacher_update_grades(grades_array, year)
    grades_array.each do |grade|
      semesters = grade.keys.filter{|key| key != "subject" && key != "key"}
      semesters.each do |semester|
      # byebug
        grade_category = self.grade_categories.find_by(klass_id: grade[:key], semester: semester, year: year)
        if grade_category
          grade_category.update(student_grade: grade[semester])
        else
          self.grade_categories.create!(klass_id: grade[:key], semester: semester, student_grade: grade[semester], year: year)
        end
      end
    end
  end
end
