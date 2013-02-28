class AgendasController < ApplicationController
  before_filter :login, :except => [:index, :show]
  # GET /agendas
  # GET /agendas.json
  def index
    @agendas = Agenda.roots.order("position")
    @write_right = userCould :timer

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agendas }
    end
  end

  def switch
    return false if !userCan :agendas
    agenda_a = Agenda.find(params[:a])
    agenda_b = Agenda.find(params[:b])

    pos_a = agenda_a.position

    agenda_a.update_attributes(:position => agenda_b.position);
    agenda_b.update_attributes(:position => pos_a);

    redirect_to agendas_url
  end

  def toggle_finished
    return false if !userCan :agendas
    @agenda = Agenda.find(params[:id])

    respond_to do |format|
      if @agenda.update_attributes(:finished => !@agenda.finished)
        format.html { redirect_to agendas_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /agendas/1
  # GET /agendas/1.json
  def show
    @agenda = Agenda.find(params[:id])
    @slides= @agenda.slides
    @slide= @slides[0] if @slides.count == 1 and !params[:slide]
    @slide= Slide.find(params[:slide]) if params[:slide]
    @menu_edit_link =  ("<a href='"+edit_agenda_path(@agenda)+"'>Edit</a>").html_safe if userCould :agendas

    if ((userCould :slide) or (userCould :projector)) and !@slide.nil? then
      @menu_cmd_link = '<a id="drop1" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">Slide<b class="caret"></b></a><ul class="dropdown-menu" role="menu" aria-labelledby="drop2">'
      Projector.all.each{|p|
        @menu_cmd_link += '<li><a href="#" onclick=\'$.post("'+(url_for p)+'", { "command[cmd]": "load", "command[slide]": "'+@slide.id.to_s+'", "authenticity_token" : "'+form_authenticity_token+'"} );\'>Auf Beamer '+p.name+'</a></li>' 
        }if userCould :projector
      @menu_cmd_link += '<li><a href="'+edit_slide_path(@slide)+'">Bearebieten</a></li>' if userCould :slide
      @menu_cmd_link += '</ul>'
      @menu_cmd_link = @menu_cmd_link.html_safe
    end

    @load_push = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agenda }
    end
  end

  # GET /agendas/new
  # GET /agendas/new.json
  def new
    return false if !userCan :agendas
    @agenda = Agenda.new
    @agendas = Agenda.roots.order("position")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agenda }
    end
  end

  # GET /agendas/1/edit
  def edit
    return false if !userCan :agendas
    @agenda = Agenda.find(params[:id])
    @agendas = Agenda.roots.order("position")
  end

  # POST /agendas
  # POST /agendas.json
  def create
    return false if !userCan :agendas
    @agenda = Agenda.new(params[:agenda])

    respond_to do |format|
      if @agenda.save
        format.html { redirect_to agendas_url }
        format.json { render json: @agenda, status: :created, location: @agenda }
      else
        format.html { render action: "new" }
        format.json { render json: @agenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agendas/1
  # PUT /agendas/1.json
  def update
    return false if !userCan :agendas
    @agenda = Agenda.find(params[:id])

    respond_to do |format|
      if @agenda.update_attributes(params[:agenda])
        format.html { redirect_to agendas_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agendas/1
  # DELETE /agendas/1.json
  def destroy
    return false if !userCan :agendas
    @agenda = Agenda.find(params[:id])
    @agenda.destroy

    respond_to do |format|
      format.html { redirect_to agendas_url }
      format.json { head :no_content }
    end
  end
end
