class User < ApplicationRecord
  acts_as_tenant :organization

  validates :email, :first_name, :last_name, :password, presence: true
  validate :domain_validation
  encrypts :password, deterministic: true

  enum :role, { student: 0, teacher: 1 }
  enum :status, { active: 0, disabled: 1 }

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def name
    [first_name, last_name].compact.join(" ")
  end

  private

  def domain_validation
    # return if teacher?

    errors.add(:email, "domain not allowed, must be @students.koi.edu.au") unless email.include?("@students.koi.edu.au")
  end
end
