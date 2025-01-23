class Students::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_student
  before_action :quiz_submitted?, only: %i[attemptting_quiz attempt_quiz]

  def index
  end

  def quizzes
    @quizzes = Quiz.all
  end

  def show_quiz
    @quiz = Quiz.find(params[:id])
  end

  def attempt_quiz
    @quiz = Quiz.find(params[:id])
    @quiz.update_column(:started, true)
    @video_request = VideoRequest.find_or_create_by(student_id: @current_user.id, quiz_id: @quiz.id)
  end

  def submit_quiz
    @quiz = Quiz.find(params[:id])

    if @quiz.update(quiz_params)
      flash[:success] = "Quiz submitted successfully."
      QuizMailer.quiz_submitted(@quiz.created_by, @current_user, @quiz).deliver_now
      redirect_to students_quizzes_path
    end
  end

  def submitted_quizzes
    # @quizzes = Quiz.where(status: "completed")
    # @quizzes = Quiz.joins(:submissions).where(submissions: { status: "completed", user_id: @current_user.id })
    @quizzes = Quiz.where(id: VideoRequest.where(student_id: @current_user.id).pluck(:quiz_id))
    # @quizzes = Quiz.where(id: VideoRequest.where(student_id: @current_user.id).where.not(quiz_id
    # @quizzes = Quiz.where(status: "submitted", user_id: @current_user.id)
  end

  def reports
    @reports = Report.all
  end

  def videos
    @videos = Video.all
  end

  def show_report
    @report = Report.find(params[:id])
  end

  def show_video
    @video = Video.find(params[:id])
  end

  def download_video
    @video = Video.find(params[:id])
    send_file @video.file.path, type: @video.file.content_type
  end

  def download_report
    @report = Report.find(params[:id])
    send_file @report.file.path, type: @report.file.content_type
  end

  def submitted
    if params[:id].present?
      @quiz = Quiz.find(params[:id])
      # @quiz.pending!
      @quiz.submissions.create(user_id: @current_user.id, status: "completed") unless @quiz.is_submitted?(@current_user.id)
      flash[:success] = "Quiz submitted successfully."
    else
      flash[:error] = "Please select a quiz to submit."
    end

    respond_to do |format|
      format.html
    end

    # respond_to do |format|
    #   format.html { redirect_to students_submitted_quizzes_path }
    # end
  end

  def attemptting_quiz
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions
    @question = @quiz.questions.find_by(id: params[:question_id])
  end

  def show_submitted
    @quiz = Quiz.find(params[:id])
  end

  private

  def quiz_submitted?
    if params[:id].present? && Quiz.find(params[:id]).is_submitted?(@current_user.id)
      flash[:error] = "You have already submitted this quiz"
      redirect_to students_submitted_quizzes_path
    elsif VideoRequest.find_by(student_id: @current_user.id, quiz_id: params[:id]).present?
      flash[:error] = "You have already tried to submit this quiz"
      redirect_to students_quizzes_path
    end
  end
end
