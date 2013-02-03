class Timer < ActiveRecord::Base
  attr_accessible :color, :default, :name, :position, :visable
  
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
end
