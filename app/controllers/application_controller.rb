# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # include ActsAsTenant::ControllerExtensions

  set_current_tenant_through_filter
  # before_action :authenticate_user! if session[:user].present?
  # before_action :set_organization_as_tenant# if session.dig("user", "id").present?

  # helper_method :current_user, :user_signed_in?

  # def check_login
  #   redirect_to root_path if user_signed_in?
  # end

  def is_teacher
    redirect_to root_path unless @current_user.teacher?
  end

  def is_student
    redirect_to root_path unless @current_user.student?
  end

  private

  def set_organization_as_tenant
    current_organization = @current_user&.organization
    set_current_tenant(current_organization)
  end

  def current_user
    @current_user ||= session[:user] ? User.find_by(id: session.dig("user", "id")) : nil
  end

  def user_signed_in?
    if current_user.present?
      set_organization_as_tenant
      true
    else
      false
    end
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:error] = "Please sign in to continue"
      redirect_to root_path
    end
  end
end




# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
#   # allow_browser versions: :modern

#   # before_action :current_user#, :require_login
#   # before_action :require_login

#   # def current_user
#   #   @current_user ||= User.find_by(id: session[:user_id])
#   # end

#   before_action :set_organization_as_tenant

#   private

#   def current_user
#     @current_user ||= session[:user] ? User.find_by(id: session[:user]["id"]) : nil
#   end

#   def set_organization_as_tenant
#     current_organization = current_user&.organization
#     set_current_tenant(current_organization)
#   end

#   def require_login
#     redirect_to rooth_path unless @current_user
#   end
# end
