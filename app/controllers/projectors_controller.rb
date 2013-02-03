class ProjectorsController < ApplicationController
  # GET /projectors
  # GET /projectors.json
  def index
    @projectors = Projector.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projectors }
    end
  end

  # GET /projectors/1
  # GET /projectors/1.json
  def show
    @projector = Projector.find(params[:id])
    @load_push = true
    
    render :layout => "full"
  end

  # GET /projectors/new
  # GET /projectors/new.json
  def new
    @projector = Projector.new
    @slides = Slide.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @projector }
    end
  end

  # GET /projectors/1/edit
  def edit
    @projector = Projector.find(params[:id])
    @slides = Slide.all
  end

  # POST /projectors
  # POST /projectors.json
  def create
    @projector = Projector.new(params[:projector])

    respond_to do |format|
      if @projector.save
        format.html { redirect_to :action => "index" }
        format.json { render json: @projector, status: :created, location: @projector }
      else
        format.html { render action: "new" }
        format.json { render json: @projector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projectors/1
  # PUT /projectors/1.json
  def update
    @projector = Projector.find(params[:id])

    respond_to do |format|
      if @projector.update_attributes(params[:projector])
        Message.Command("id" => "projector-"+params[:id], "cmd" => "load", "slide" => @projector.slide_id)
        format.html { redirect_to :action => "index" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @projector.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /projectors/1
  # POST /projectors/command
  def command
    params[:command]["id"] = "projector-"+params[:id]
    params[:command]["id"] = "projector" if params[:id] == "command"
    Message.Command params[:command]
    redirect_to projectors_url
  end

  # DELETE /projectors/1
  # DELETE /projectors/1.json
  def destroy
    @projector = Projector.find(params[:id])
    @projector.destroy

    respond_to do |format|
      format.html { redirect_to projectors_url }
      format.json { head :no_content }
    end
  end
end
