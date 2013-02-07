class ApplicationController < ActionController::Base
  protect_from_forgery

  def userCan right
    login if !@current_user
    render :action => "denied" and return false if !@current_user.can? right
    true
  end

  def login
    @current_user = nil
    redirect_to :controller => "users", :action => "user_login" and return  if session[:user_id].nil?
    @current_user= User.find session[:user_id]
  end
end
