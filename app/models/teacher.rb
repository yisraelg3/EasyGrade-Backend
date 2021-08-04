class Teacher < ApplicationRecord
  has_secure_password :password, validations: false
  belongs_to :admin
  has_many :klasses
  has_many :students, -> { distinct }, through: :klasses
  has_many :grade_categories, through: :klasses

  validates :title, presence:true
  validates :last_name, presence: true

  # validates :username, uniqueness: true

  def professional_title
    "#{title} #{last_name}".strip
  end

  def account_type
    self.class.name
  end
end
