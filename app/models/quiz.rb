class Quiz < ApplicationRecord
  acts_as_tenant :organization

  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true

  enum :status, { active: 0, in_progress: 1, pending: 2, completed: 3, failed: 4 }


  def total_time
    questions.sum(:duration)
  end

  def is_submitted?(user_id)
    submissions.where(status: 2, user_id: user_id).any?
  end

  def submissions_status(user_id)
    if is_submitted?(user_id)
      "Submitted"
    else
      "Active"
    end
  end

  # def get_status
  #   if pending?
  #     "Done"
  #   else
  #     "Active"
  #   end
  # end

  def score(user_id)
    questions = self.questions
    answers = Answer.where(student_id: user_id, question_id: questions.pluck(:id))
    marks = Mark.where(answer_id: answers.pluck(:id))
    marks.sum(:number)
  end
end
