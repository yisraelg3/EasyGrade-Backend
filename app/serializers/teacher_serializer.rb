class TeacherSerializer < ActiveModel::Serializer
  attributes :id, :username, :title, :first_name, :last_name, :professional_title, :picture_url
  has_many :students
  has_many :klasses
  has_many :grade_categories
end
