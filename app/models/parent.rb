class Parent < ApplicationRecord
  has_secure_password :password, validations: false
  belongs_to :admin
  has_many :students #, dependent: :destroy
  has_many :grade_categories, through: :students
  has_many :klasses, through: :students

  validates :username, presence: true
  # validates :username, uniqueness: true

  def account_type
    self.class.name
  end
end
