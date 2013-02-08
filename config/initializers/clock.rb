if !defined?(Rails::Console) then
  Thread.new do
    while true do
      sleep 1
      data = []

      data.push({"id" => "main","unix" => Time.now.to_i})

      Timer.all.each { | t |
        data.push(t.pusch_data)
      }

      Message.Clock data
    end
  end
end