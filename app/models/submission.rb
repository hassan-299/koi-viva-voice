class Submission < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :quiz
  belongs_to :user

  enum :status, { in_progress: 0, submitted: 1, completed: 2 }
end
