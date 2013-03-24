class AdminController < ApplicationController
  before_filter :login
  def index
    return false if !userCan :admin
    begin
      @books = [];
      require 'net/http'
      Net::HTTP.get_response(URI.parse("http://antragsbuch.piratech.de/api/1/buch")).body.split("\n").each{|l|
        @books.push ActiveSupport::JSON.decode(l)
      }
    rescue
      @books = []
    end
  end

  def load_antrag
    require 'net/http'
    Net::HTTP.get_response(URI.parse("http://antragsbuch.piratech.de/api/1/buch/"+params[:load])).body.split("\n").each{|l|
      d= ActiveSupport::JSON.decode(l)
      if d["_type"] == "antrag" then
        s= Slide.find_or_create_by_unique d["uniq"]
        s.data = {} if s.data.nil?
        s.data["antrag"] = {} if s.data["antrag"].nil?
        s.art = "Antrag"
        s.name= d["id"]+" - "+d["title"]

        s.data["antrag"]["parser"]  = "HTML"
        s.data["antrag"]["state"]   = "Offen" if s.data["antrag"]["state"].nil?

        s.data["antrag"]["id"]      = d["id"]
        s.data["antrag"]["owner"]   = d["owner"]
        s.data["antrag"]["short"]   = d["vorw"]
        s.data["antrag"]["text"]    = d["text"]
        s.data["antrag"]["reason"]  = d["nachw"]
        s.data["antrag"]["note"]    = ""
        s.data["antrag"]["link"]    = ""
      s.save
      end
      if d["_type"] == "gruppe" then
        s= Slide.find_or_create_by_unique d["uniq"]
        if s.item.nil? then
          ib = Item.find_or_create_by_name d["gruppe"]
          ic = ib.children.find_or_create_by_name d["name"]
          s.data["antrag"]["link"]    = "Gruppe|"+(url_for s.item)+"|"+d["name"]+"\n"
          s.item = ic
          s.save
        end
      end
    }

    Message.Command "id" => "projector", "cmd" => "reload"
    redirect_to :action => "index"
  end

  def import_antrag
    return false if !userCan :admin

    ActiveSupport::JSON.decode(params["json"].tempfile.read).each do |d|
      s= Slide.find_or_create_by_unique d["id"]
      s.data = {} if s.data.nil?
      s.data["antrag"] = {} if s.data["antrag"].nil?
      if s.item.nil? then
        ib = Item.find_or_create_by_name d["typ"]
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
