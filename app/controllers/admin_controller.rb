class AdminController < ApplicationController
  def index
  end

  def import_antrag
    ia = Item.find :first

    ActiveSupport::JSON.decode(params["json"].tempfile.read).each do |d|
      s= Slide.find_or_create_by_unique d["id"]
      s.data = {} if s.data.nil?
      s.data["antrag"] = {} if s.data["antrag"].nil?
      if s.item.nil? then
        ib = ia.children.find_or_create_by_name d["typ"]
        ic = ib.children.find_or_create_by_name d["gruppe"]
        s.item = ic
      end

      s.art = "Antrag"
      s.name= d["id"]+" - "+d["titel"]
      s.data["antrag"]["parser"]  = "HTML"
      s.data["antrag"]["state"]   = "Offen" if s.data["antrag"]["state"].nil?

      s.data["antrag"]["id"]      = d["id"]
      s.data["antrag"]["owner"]   = d["autor"]
      s.data["antrag"]["short"]   = d["zusammenfassung"]
      s.data["antrag"]["text"]    = d["text"]
      s.data["antrag"]["reason"]  = d["begruendung"]
      s.data["antrag"]["note"]    = "Type|"+d["typ"]+"\n"
      s.data["antrag"]["note"]    += "Konkurrenz|"+d["konkurrenz"]+"\n" if d["konkurrenz"] != ""

      s.data["antrag"]["link"]    = "Gruppe|"+(url_for s.item)+"|"+d["gruppe"]+"\n"
      s.data["antrag"]["link"]    += "Wiki|"+d["wiki"]+"|Wiki\n" if d["wiki"] != ""
      s.data["antrag"]["link"]    += "Pad|"+d["pad"]+"|Pad\n" if d["pad"] != ""
      s.data["antrag"]["link"]    += "LQFB|"+d["lqfb"]+"|LQFB\n" if d["lqfb"] != ""

      s.save
    end
    Message.Command "id" => "projector", "cmd" => "reload"
    redirect_to :action => "index"
  end
end
