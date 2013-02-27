class Agenda < ActiveRecord::Base
  attr_accessible :name, :position, :parent, :parent_id
  has_paper_trail :on => [:update, :destroy]
  after_create :generate_position
  has_ancestry
  has_many :slides

  def generate_position
    self.position = self.id
    self.save
  end
end
