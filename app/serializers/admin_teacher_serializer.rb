class AdminTeacherSerializer < ActiveModel::Serializer
  attributes :id, :username, :password, :title, :first_name, :last_name, :professional_title, :picture_url
end
