class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_user

  def load_user
    @current_user= User.find session[:user_id] if !session[:user_id].nil?
  end

  def userCould right
    if !@current_user then
      return false if session[:user_id].nil?
      @current_user= User.find session[:user_id]
    end
    @current_user.can? right
  end

  def userCan right
    login if !@current_user
    render :action => "denied" and return false if !@current_user.can? right
    true
  end

  def login
    redirect_to :controller => "users", :action => "user_login" and return if !@current_user
    @current_user= User.find session[:user_id]
  end
end
