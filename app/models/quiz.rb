class Quiz < ApplicationRecord
  acts_as_tenant :organization

  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true
  validate :start_time_before_end_date

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

  private

  def start_time_before_end_date
    return if start_time.blank? || end_time.blank?

    if start_time >= end_time
      errors.add(:start_time, "must be before end date")
    end

    if due_date < Date.today
      errors.add(:due_date, "must be in the future")
    end
  end
end
