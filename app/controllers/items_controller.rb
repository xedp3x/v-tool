class ItemsController < ApplicationController
  before_filter :login, :except => [:index, :show]
  # GET /items
  # GET /items.json
  def index
    @items = Item.find(:all, :order => "position")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def switch
    return false if !userCan :items
    item_a = Item.find(params[:a])
    item_b = Item.find(params[:b])

    pos_a = item_a.position

    item_a.update_attributes(:position => item_b.position);
    item_b.update_attributes(:position => pos_a);

    redirect_to items_url
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @slides= @item.slides
    @slide= @slides[0] if @slides.count == 1 and !params[:slide]
    @slide= Slide.find(params[:slide]) if params[:slide]

    @load_push = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    return false if !userCan :items
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    return false if !userCan :items
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    return false if !userCan :items
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        @item.update_attributes(:position => @item.id)
        format.html { redirect_to items_url }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    return false if !userCan :items
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to items_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    return false if !userCan :items
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
