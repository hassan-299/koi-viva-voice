class AdminsController < ApplicationController
  before_action :is_signed_in, except: %i[sign_in log_in]
  expose :admin

  def log_in
    return redirect_to "/admin" if Admin.find_by(id: session.dig("admin", "id")).present?

    admin = Admin.find_by(username: admin_params[:username], password: admin_params[:password])# || User.find_by(email: user_params[:email], password: user_params[:password])

    if admin.present?
      flash[:success] = "Signed in successfully"
      session[:admin] = { id: admin.id } # Store only the ID

      redirect_to "/admin"
    else
      flash[:error] = "Invalid username or password"
      redirect_to sign_in_path
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :password)
  end
end
