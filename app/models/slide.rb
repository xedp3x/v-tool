class Slide < ActiveRecord::Base
  attr_accessible :art, :data, :name, :item, :item_id
  serialize :data
  belongs_to :item
  after_save :send_update
  has_many :projector

  def send_update
    sc= SlidesController.new
    sc.publish self
  end
end
