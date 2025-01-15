class DashboardsController < ApplicationController
  def index
    if session[:user]
      flash[:info] = "You are already signed in"
      current_user = User.find_by(id: session.dig("user", "id"))

      redirect_to current_user.student? ? students_portal_path : teachers_portal_path
    end
  end
end
