class GradeCategorySerializer < ActiveModel::Serializer
  attributes :id, :category, :student_grade, :year, :semester, :comment, :klass_id, :student_id
end
