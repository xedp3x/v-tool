class Slide < ActiveRecord::Base
  attr_accessible :art, :data, :name, :item, :item_id, :agenda, :agenda_id
  has_paper_trail :ignore => [:item_id], :unless => Proc.new { |t| t.data.nil? }
  serialize :data
  belongs_to :item
  belongs_to :agenda
  after_save :send_update
  has_many :projector

  def send_update
    sc= SlidesController.new
    sc.publish self
  end
end
