class ParentSerializer < ActiveModel::Serializer
  attributes :id, :username, :account_type
  has_many :students
  has_many :grade_categories
  has_many :klasses
end
