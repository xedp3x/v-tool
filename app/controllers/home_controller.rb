class HomeController < ApplicationController
  def index
  end
  
  def debug
    @load_push = true
  end
end
