class Item < ActiveRecord::Base
  attr_accessible :name, :position, :parent, :parent_id
  has_ancestry
  
  has_many :slides
end
