class Teachers::TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_teacher

  def index
  end

  def students
    @students = User.where(role: "student")
  end

  def new_student
    @student = User.new
  end

  def add_student
    @student = User.new(student_params)
    @student.username = @student.email
    @student.role = "student"
    @student.password = "123456"

    if @student.save
      flash[:success] = "Student created successfully"
    else
      flash[:error] = @student.errors.full_messages.join(", ")
    end
    redirect_to teachers_students_path
  end

  def show_student
    @teacher = User.find(@current_user.id)
    @student = User.find(params[:id])
  end

  def edit_student
    @student = User.find(params[:id])
  end

  def update_student
    @student = User.find(params[:id])

    if @student.update(student_params)
      flash[:success] = "Student updated successfully"
    else
      flash[:error] = @student.errors.full_messages.join(", ")
    end
    redirect_to teachers_students_path
  end

  def destroy_student
    @student = User.find(params[:id])
    if @student.destroy
      flash[:success] = "Student deleted successfully"
      redirect_to teachers_students_path
    end
  end

  private

  def student_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :email, :role, :status, :failed_attempts)
  end
end
