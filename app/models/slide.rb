class Slide < ActiveRecord::Base
  attr_accessible :art, :data, :name, :item, :item_id
  serialize :data
  belongs_to :item
  has_many :projector
end
