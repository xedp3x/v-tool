class SlidesController < ApplicationController
  before_filter :login, :except => [:index, :show]
  # GET /slides
  # GET /slides.json
  def index
    @write_right = userCould :slide
    if params[:search] then
      @slides = Slide.find(:all, :conditions => ["name LIKE ?", "%#{params[:search]}%"])
      redirect_to @slides[0] if @slides.count == 1
    else
      @slides = Slide.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @slides }
      end
    end
  end

  def publish(slide)
    @slide = slide
    @broadcast=true;
    data = render_to_string(:action => "show",:layout => false)
    Message.Send("slide-#{slide.id}",{ :type => "data", :id => "slide-#{slide.id}", :data => data})
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
    @slide = Slide.find(params[:id])
    @load_push = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @slide }
      format.text { @broadcast=true; render :text => render_to_string('_show', :layout => false, :formats => "html") }
    end
  end

  # GET /slides/new
  # GET /slides/new.json
  def new
    return false if !userCan :slide
    @slide = Slide.new
    @items = Item.find(:all, :order => "position")
    @projectors = Projector.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slide }
    end
  end

  # GET /slides/1/edit
  def edit
    return false if !userCan :slide
    @slide = Slide.find(params[:id])
    @items = Item.find(:all, :order => "position")
    @projectors = Projector.all

    @load_push=true;
  end

  # POST /slides
  # POST /slides.json
  def create
    return false if !userCan :slide
    @slide = Slide.new(params[:slide])

    respond_to do |format|
      if @slide.save
        if params[:projector_add] then
          params[:projector_add].each {|v|
            Projector.find(v).update_attributes(:slide_id => params[:id]);
            Message.Command(:id => "projector-#{v}", :cmd => "load", :slide => params[:id])
          }
        end
        format.html { redirect_to @slide, notice: 'Slide was successfully created.' }
        format.json { render json: @slide, status: :created, location: @slide }
      else
        format.html { render action: "new" }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /slides/1
  # PUT /slides/1.json
  def update
    return false if !userCan :slide
    @slide = Slide.find(params[:id])

    respond_to do |format|
      if @slide.update_attributes(params[:slide])
        if params[:projector_add] then
          params[:projector_add].each {|v|
            Projector.find(v).update_attributes(:slide_id => params[:id]);
            Message.Command(:id => "projector-#{v}", :cmd => "load", :slide => params[:id])
          }
        end
        format.html { redirect_to @slide, notice: 'Slide was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    return false if !userCan :slide
    @slide = Slide.find(params[:id])
    @slide.destroy
    Message.Send("slide-#{params[:id]}",{ :type => "data", :id => "slide-#{params[:id]}", :data => "<h1 class='middel'>Slide has been removed!</h1>"})

    respond_to do |format|
      format.html { redirect_to slides_url }
      format.json { head :no_content }
    end
  end
end
