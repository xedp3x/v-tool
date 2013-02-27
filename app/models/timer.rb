class Timer < ActiveRecord::Base
  attr_accessible :color, :default, :name, :position, :visable
  has_paper_trail
  after_save :send_update
  
  def activ?
    self.position < - 1000000
  end

  def now?
    if self.activ? then
      0 - Time.now.to_i - self.position
    else
      self.position
    end
  end

  def start
    if ! self.activ? then
      self.position = 0 - Time.now.to_i - self.position
      self.save
    end
  end

  def stop
    if self.activ? then
      self.position = 0 - Time.now.to_i - self.position
      self.save
    end
  end

  def pusch_data
    return {
          "id"    => self.id,
          "unix"  => self.now?,
          "activ" => self.activ?,
          "name"  => self.name,
          "color" => self.color,
          "visable" => self.visable
     }
  end

  def send_update
    Message.Clock [self.pusch_data]
  end
end
