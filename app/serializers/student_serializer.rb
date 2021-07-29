class StudentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birth_date, :picture_url, :parent_id
end
