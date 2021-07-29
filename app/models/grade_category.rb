class GradeCategory < ApplicationRecord
  belongs_to :student, optional: true
  belongs_to :klass

  # validates :category, uniqueness: true, if: -> {Klass.all.pluck(:id).include?(Proc.new.klass_id)}
end
