class TimersController < ApplicationController
  before_filter :login, :except => [:index, :show]

  # GET /timers
  # GET /timers.json
  def index
    @timers = Timer.all
    @load_push = true

    @write_right = userCould :timer

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timers }
    end
  end

  # GET /timers/1
  # GET /timers/1.json
  def show
    @timer = Timer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timer }
    end
  end

  # GET /timers/new
  # GET /timers/new.json
  def new
    return false if !userCan :timer
    @timer = Timer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timer }
    end
  end

  # GET /timers/1/edit
  def edit
    return false if !userCan :timer

    @timer = Timer.find(params[:id])
  end

  # POST /timers
  # POST /timers.json
  def create
    return false if !userCan :timer

    @timer = Timer.new(params[:timer])

    respond_to do |format|
      if @timer.save
        format.html { redirect_to @timer, notice: 'Timer was successfully created.' }
        format.json { render json: @timer, status: :created, location: @timer }
      else
        format.html { render action: "new" }
        format.json { render json: @timer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timers/1
  # PUT /timers/1.json
  def update
    return false if !userCan :timer

    @timer = Timer.find(params[:id])

    respond_to do |format|
      if @timer.update_attributes(params[:timer])
        format.html { redirect_to @timer, notice: 'Timer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timer.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /timers/1
  def set
    return false if !userCan :timer

    timer = Timer.find(params[:id])

    case params[:set]
    when "start"  
       timer.start
    when "stop"  
       timer.stop
    when "show"  
       timer.visable= true
       timer.save
    when "hide"  
       timer.visable= false
       timer.save
    when "start_show"  
       timer.visable= true
       timer.start
       timer.save
    when "stop_hide"  
       timer.visable= false
       timer.stop
       timer.save
    when "reset"  
       timer.position = timer.default
       timer.save      
    end

    render :text => "OK"
  end

  # DELETE /timers/1
  # DELETE /timers/1.json
  def destroy
    return false if !userCan :timer

    @timer = Timer.find(params[:id])
    @timer.destroy

    respond_to do |format|
      format.html { redirect_to timers_url }
      format.json { head :no_content }
    end
  end
end