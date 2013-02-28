class HomeController < ApplicationController
  def index
    @slide = Slide.find_by_name "HOME"
    return false if @slide.nil?
    render :template => "slides/_show"
  end
  
  def error_404
    @error = 404
    render 'error'
  end
  def error_422
    @error = 422
    render 'error'
  end
  def error_500
    @error = 500
    render 'error'
  end

  def debug
    @load_push = true
  end
end
