class Admin < ApplicationRecord
    has_secure_password
    has_many :teachers, -> {order(:id)}
    has_many :parents
    has_many :klasses, through: :teachers
    has_many :students, through: :parents
    has_many :grade_categories, through: :klasses

    validates :username, uniqueness: true

    validates :username, presence:true
    validates :title, presence:true
    validates :last_name, presence:true

    def professional_title
        "#{title} #{last_name}".strip
    end

    def create_default
        teacher = self.teachers.create!(title: "No", last_name: "teacher")
        # teacher.klasses.create!(grade: "No ", subject: "class")
        parent = self.parents.create!()
    end
end
