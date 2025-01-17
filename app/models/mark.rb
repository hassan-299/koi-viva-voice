class Mark < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :answer

  validates :number, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
