class GradeCategory < ApplicationRecord
  belongs_to :student, optional: true
  belongs_to :klass

  # validates :category, uniqueness: true, if: -> {Klass.all.pluck(:id).include?(Proc.new.klass_id)}

  def subject
    self.klass.subject
  end

  def name
    "#{self.student.first_name} #{self.student.last_name}"
  end
end
