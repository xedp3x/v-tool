class Item < ActiveRecord::Base
  attr_accessible :name, :position, :parent, :parent_id
  after_create :generate_position
  has_ancestry
  has_many :slides

  def generate_position
    self.position = self.id
    self.save
  end
end
