class Mark < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :answer
end
