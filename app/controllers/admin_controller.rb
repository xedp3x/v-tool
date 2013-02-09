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
      s.data["antrag"]["note"]    = "Gruppe|#{d["gruppe"]}\nType|#{d["kind"]}"
      s.data["antrag"]["link"]    = "Wiki|#{d["wiki"]}|Wiki"

      s.save
    end
    render :action => "index"
  end
end
