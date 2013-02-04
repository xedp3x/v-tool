class Projector < ActiveRecord::Base
  attr_accessible :name, :slide_id, :slide, :has_timer
  
  belongs_to :slide
end
