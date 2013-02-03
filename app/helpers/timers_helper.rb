module TimersHelper
  def format_time (time)
    t = time
    t = 0 - time if time < 0
    min = (t / 60).to_s
    min = "0"+min if min.length == 1
    sec = (t % 60).to_s
    sec = "0"+sec if sec.length == 1
    back = min+":"+sec
    back = "-"+min+":"+sec if time < 0
    back
  end
end
