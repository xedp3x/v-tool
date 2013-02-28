class UsersController < ApplicationController
  before_filter :login, :except => :user_login
  
  def user_login
    if params[:name] then
      u= User.find_by_name(params[:name])
      begin
        if u.password? params[:password] then
          session[:user_id]= u.id
          redirect_to :controller => "home", :action => "index"
        else
          @error = "Username oder Passwort ist falsch"
        end
      rescue
        @error = "Username oder Passwort ist falsch"
      end
    end
    if params[:out] then
       reset_session
       redirect_to :action => 'user_login'
    end
  end

  # GET /users
  # GET /users.json
  def index
    return false if !userCan :user
    @users = User.all
    @write_right = userCould :user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to :action => "index"
  end

  # GET /users/new
  # GET /users/new.json
  def new
    return false if !userCan :user
    @user = User.new
    @user.rights= {}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    return false if !userCan :user
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    return false if !userCan :user
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    return false if !userCan :user
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    return false if !userCan :user
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
