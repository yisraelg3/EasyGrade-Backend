class KlassSerializer < ActiveModel::Serializer
  attributes :id, :subject, :grade, :locked, :teacher_id
end
