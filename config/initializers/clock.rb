Thread.new do
  while true do
    sleep 1
    data = []
    
    data.push({"id" => "main","unix" => Time.now.to_i})
    
    Message.Clock data
  end
end