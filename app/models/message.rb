class Message 
  
  def self.Send(id,data)
    Juggernaut.publish(["data",id], data)
  end
  
  def self.Command(command)
    Juggernaut.publish("command", command)
  end
  
  def self.Clock(data)
    Juggernaut.publish("clock", data)
  end
  
end
