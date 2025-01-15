class Answer < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :question
  belongs_to :video, optional: true
  has_one :mark
end
