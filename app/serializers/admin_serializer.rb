class AdminSerializer < ActiveModel::Serializer
  attributes :id, :username, :professional_title, :account_type
  has_many :teachers, serializer: AdminTeacherSerializer
  has_many :klasses
  has_many :students
  has_many :parents, serializer: AdminParentSerializer
  has_many :grade_categories
end
