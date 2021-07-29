class Parent < ApplicationRecord
  has_secure_password :password, validations: false
  belongs_to :admin
  has_many :students, dependent: :destroy
end
