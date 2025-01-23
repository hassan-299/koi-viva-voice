class Teachers::QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :is_teacher
  expose :quizzes, -> { Quiz.where(created_by_id: @current_user.id) }
  expose :quiz

  def index
  end

  def edit
    if quiz.started?
      flash[:error] = "This quiz is already started."
    end
  end

  def create
    # quiz.start_time = Time.now
    # quiz.end_time = Time.now
    quiz.created_by_id = @current_user.id

    if quiz.save
      QuizMailer.quiz_created_email(@current_user, quiz).deliver_now
      respond_to do |format|
        flash[:success] = "Quiz is created successfully."
        format.html { redirect_to teachers_quizzes_path }
      end
    else
      flash[:error] = quiz.errors.full_messages
      render :new
    end
  end

  def update
    if quiz.update(quiz_params)
      respond_to do |format|
        flash[:success] = "Quiz is updated successfully."
        format.html { redirect_to teachers_quizzes_path }
      end
    else
      flash[:error] = quiz.errors.full_messages
      render :edit
    end
  end

  def destroy
    if quiz.destroy
      respond_to do |format|
        flash[:alert] = "Quiz is deleted successfully."
        format.html { redirect_to teachers_quizzes_path }
      end
    end
  end

  def submitted
    @submissions = Submission.joins(:quiz).where(quizzes: { created_by_id: @current_user.id }).where(status: "completed")
    # @submissions = Quiz.where(id: VideoRequest.pluck(:quiz_id))
    # @quizzes = Quiz.where(created_by_id: @current_user.id).joins(:submissions).where(submissions: { status: "completed" })
  end

  def show_submitted
    @quiz = Quiz.find(params[:quiz_id])
    @submission = Submission.find_by(id: params[:submission_id])
  end

  def mark_question
    mark = Mark.find_or_initialize_by(answer_id: params[:id], teacher_id: @current_user.id)
    if mark.update(number: params[:number], comment: params[:comment])
      answer = Answer.find_by(id: params[:id])
      if answer.present?
        student = User.find_by(id: answer.student_id)
        quiz = answer.question.quiz
        test = false
        quiz.questions.each do |q|
          unless Mark.find_by(answer_id: q.answers.where(student_id: student.id, is_published: true).last&.id, teacher_id: @current_user.id)
            test = false
          else
            test = true
          end
        end
        QuizMailer.quiz_marked(student, quiz, "A+").deliver_now if test
      end
      flash[:success] = "Answer marked successfully."
    else
      flash[:error] = "Failed to save the mark. Please try again."
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :description, :due_date, :start_time, :end_time, :status, questions_attributes: %i[id title duration description _destroy])
  end
end
