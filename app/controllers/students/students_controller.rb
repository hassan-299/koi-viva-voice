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

    if params[:start].present? && VideoRequest.find_by(student_id: @current_user.id, quiz_id: @quiz.id).present?
      flash[:error] = "You have already tried to submit this quiz"
      redirect_to students_quizzes_path
      return
    end
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
    if params[:id].present?
      Submission.create(user_id: @current_user.id, status: "completed", quiz_id: params[:id])
      flash[:success] = "Quiz submitted successfully."
    end
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

      q_count = @quiz.questions.count
      v_count = 0
      @quiz.questions.each do |question|
        v_count += 1 if VideoRequest.find_by(student_id: @current_user.id, question_id: question.id)
      end
      unless q_count.eql?(v_count)
        flash[:error] = "Please attempt all the questions before submitting."
        redirect_to students_attemptting_quiz_path(@quiz, @quiz.questions&.last)
        return
      end
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
    end
    # elsif VideoRequest.find_by(student_id: @current_user.id, quiz_id: params[:id]).present?
    #   flash[:error] = "You have already tried to submit this quiz"
    #   redirect_to students_quizzes_path

    if params[:id].present?
      if Quiz.find(params[:id]).due_date == Date.today
        time = Time.parse(Quiz.find(params[:id]).end_time.to_s)
        quiz_hour = time.hour
        quiz_minute = time.min

        # time = Time.current
        time = Time.now
        hour = time.hour
        minute = time.min
        if hour > quiz_hour || (hour == quiz_hour && minute > quiz_minute)
          flash[:error] = "You have missed the deadline for this quiz"
          redirect_to students_quizzes_path
        end
      elsif Quiz.find(params[:id]).due_date < Date.today
        flash[:error] = "You have missed the deadline for this quiz"
        redirect_to students_quizzes_path
      end
    end
  end
end
