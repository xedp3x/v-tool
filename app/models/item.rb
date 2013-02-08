class Item < ActiveRecord::Base
  attr_accessible :name, :position, :parent
  has_ancestry
  
  has_many :slides
end
