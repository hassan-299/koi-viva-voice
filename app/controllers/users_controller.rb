class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[create sign_in sign_up sign_out]
  expose :user

  def create
    user = User.new(user_params)
    user.username = user.email if user.username.nil?
    user.organization_id = Organization.find_by(name: "KOI VIVA VOICE").id # TODO:: Replace with the actual organization ID

    if user.save
      flash[:success] = "Account created successfully"
      session[:user] = { id: user.id } # Store only the ID

      redirect_to user.student? ? students_portal_path : teachers_portal_path
    elsif user.errors.any?
      flash[:error] = user.errors.full_messages.join(", ")
      render :sign_up
    else
      flash[:error] = "Invalid username or password"
      redirect_to root_path
    end
  end

  def sign_in
    user = User.find_by(username: user_params[:username], password: user_params[:password])# || User.find_by(email: user_params[:email], password: user_params[:password])

    if user.present?
      flash[:success] = "Signed in successfully"
      session[:user] = { id: user.id } # Store only the ID

      redirect_to user.student? ? students_portal_path : teachers_portal_path
    else
      flash[:error] = "Invalid username or password"
      redirect_to root_path
    end
  end

  def sign_out
    session.delete(:user)
    flash[:success] = "Signed out successfully"

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :email, :role, :status, :failed_attempts)
  end
end
