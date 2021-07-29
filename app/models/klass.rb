class Klass < ApplicationRecord
  belongs_to :teacher
  has_many :grade_categories, dependent: :destroy
  has_many :students, through: :grade_categories

  validates :subject, presence: true
  validates :teacher, presence: true
  validates :grade, presence: true

  def create_grade_categories_for_student(student)
    # byebug
    self.grade_categories.uniq{|category| category.category}.map do |grade_category| 
      self.grade_categories.create!(category: grade_category.category, student: student, klass: self)
    end
  end

  def create_grade_categories_from_array(student_id_array)
    # byebug
    student_id_array.map do |student_id|
      # byebug
      # self.grade_categories.uniq{|category| category.category}.each do |grade_category| 
        self.grade_categories.create!(student_id: student_id) 
      # end
    end
  end

  def destroy_grade_categories_from_array(student_id_array)
    student_id_array.each do |student_id| 
      grade_category_to_delete = self.grade_categories.find_by!(student_id: student_id)
      grade_category_to_delete.destroy
    end
  end

  def categories
    self.grade_categories.where(student_id: nil).pluck(:category)
  end

  def create_grade_categories_for_new_klass(grade_categories)
    # byebug
    grade_categories.map do |category|
      self.grade_categories.create!(category: category)
    end
  end
end
