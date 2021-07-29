class ParentSerializer < ActiveModel::Serializer
  attributes :id, :username
  has_many :students
  has_many :grade_categories
end
