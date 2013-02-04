if !defined?(Rails::Console) then
  Thread.new do
    while true do
      sleep 1
      data = []

      data.push({"id" => "main","unix" => Time.now.to_i})

      timers = Timer.all
      timers.each { | t |
        data.push({
          "id"    => t.id,
          "unix"  => t.now?,
          "activ" => t.activ?,
          "name"  => t.name,
          "color" => t.color,
          "visable" => t.visable
        })
      }

      Message.Clock data
    end
  end
end