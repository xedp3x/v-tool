class Projector < ActiveRecord::Base
  attr_accessible :name, :slide_id, :slide
  
  belongs_to :slide
end
