class Organization < ApplicationRecord
  has_many :users
  has_many :quizzes
  has_many :questions
  has_many :answers
  has_many :marks
  has_many :submissions
  has_many :videos
end
