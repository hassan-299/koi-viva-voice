class Question < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :quiz
  has_many :answers

  validates :title, presence: true

  def next_question
    quiz.questions.where("id > ?", id).first
  end

  def previous_question
    quiz.questions.where("id < ?", id).last
  end

  def is_last?
    next_question.nil?
  end

  def is_first?
    previous_question.nil?
  end

  def number
    quiz.questions.where("id < ?", id).count + 1
  end
end
