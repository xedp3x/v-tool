class HomeController < ApplicationController
  def index
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
