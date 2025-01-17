class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: %i[ show edit update destroy ]

  # GET /videos or /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1 or /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    return if params[:video][:question_id].nil?

    student_id = @current_user.id
    @question = Question.find_by(id: params[:video][:question_id])
    @quiz = @question.quiz
    # @quiz.in_progress!

    if params[:video][:live].present?
      @video = Video.find_or_create_by(student_id:, question_id: @question.id)
      @video.file.purge if @video&.file&.attached?
      @video.update(file: params[:video][:live], title: "uploaded")

      answer = Answer.find_or_create_by(student_id:, question_id: @question.id)
      answer.answer = params[:video][:live]
      answer.video_id = @video.id
      answer.is_published = true
      answer.save
    else
      @video = Video.find_by(student_id:, question_id: @question.id)
      @question.answers&.where(student_id:)&.last&.update_column(:is_published, true) if @video&.present?
    end

    # if params[:video][:file].present? # uploaded video
    #   @video = Video.find_or_create_by(student_id:, question_id: @question.id)
    #   @video.update(file: params[:video][:file], title: "uploaded")

    #   answer = Answer.find_or_create_by(student_id:, question_id: @question.id)
    #   answer.answer = params[:video][:answer]
    #   answer.video_id = @video.id
    #   answer.save
    # end
    # if params[:video][:live].present? # live video
    #   @video = Video.find_or_create_by(student_id:, question_id: @question.id)
    #   @video.update(file: params[:video][:live], title: "live")

    #   answer = Answer.find_or_create_by(student_id:, question_id: @question.id)
    #   answer.answer = params[:video][:answer] if params[:video][:answer]
    #   answer.video_id = @video.id if @video.id
    #   answer.save
    # end
    # if params[:video][:file].nil? && params[:video][:live].nil? # text answer
    #   answer = Answer.find_or_create_by(student_id:, question_id: @question.id)
    #   answer.update(answer: params[:video][:answer])
    # end

    respond_to do |format|
      if @video.nil? || @video&.errors&.any? || @video.file&.nil?
        flash[:error] = @video&.errors&.full_messages&.join(", ") || "Please upload a video"
        format.json { render :new, status: :unprocessable_entity }
        format.html { redirect_to students_attemptting_quiz_path(@quiz, @question) }
      else
        format.json { render :show, status: :created, location: @video }
        format.html { redirect_to students_attemptting_quiz_path(@quiz, @question), notice: "Answer was successfully saved." }
      end
      # if @video.save
      #   # format.html { redirect_to @video, notice: "Video was successfully created." }
      # else
      #   # format.html { render :new, status: :unprocessable_entity }
      #   format.json { render json: @video.errors, status: :unprocessable_entity }
      # end
    end

    # if params[:video][:question_id]
    #   Question.find_by(id: params[:video][:question_id]).quiz.update(status: "in_progress")
    # end
    # if params[:video][:file].present? && params[:video][:question_id].present?
    #   @video = Video.create(title: params[:video][:title], file: params[:video][:file])
    #   Answer.create(question_id: params[:video][:question_id], answer: params[:video][:answer], video_id: @video.id)
    #   redirect_to students_submitted_path
    # elsif params[:video][:file].present? && params[:video][:answer].nil?
    #   @video = Video.create(title: params[:video][:title], file: params[:video][:file])
    #   Answer.create(question_id: params[:video][:question_id], answer: params[:video][:answer], video_id: @video&.id)
    #   redirect_to students_submitted_path
    # elsif params[:video][:file].nil? && params[:video][:question_id].present?
    #   Answer.create(question_id: params[:video][:question_id], answer: params[:video][:answer], video_id: Video.last&.id)
    #   redirect_to students_submitted_path
    # else
    #   @video = Video.new(video_params)

    #   respond_to do |format|
    #     if @video.save
    #       format.html { redirect_to @video, notice: "Video was successfully created." }
    #       format.json { render :show, status: :created, location: @video }
    #     else
    #       format.html { render :new, status: :unprocessable_entity }
    #       format.json { render json: @video.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy!

    respond_to do |format|
      format.html { redirect_to videos_path, status: :see_other, notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.expect(video: [ :title, :description, :file ])
    end
end
