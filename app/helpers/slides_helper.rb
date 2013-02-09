module SlidesHelper
  def parse_antrag(text)
    return text if @slide.data["antrag"]["parser"] == "Text"
    return text.html_safe if @slide.data["antrag"]["parser"] == "HTML"
    return Creole.creolize(text).html_safe if @slide.data["antrag"]["parser"] == "Creole"
    return Marker.parse(text).to_html.html_safe if @slide.data["antrag"]["parser"] == "Wiki"
    return "-- unkown Parser --"
  end
end
