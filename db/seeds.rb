# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u= User.create :name => "admin", :password => "admin"
u.allow :admin
u.save

5.times do |i|
  itm= Item.create(:name => "TO "+i.to_s)
  3.times do |s|
    Slide.create(:art => "Text", :item_id => itm.id, :name => "Slide "+i.to_s+"-"+s.to_s, :data => {"text" => "== TEXT \\o/"})
  end
  2.times do |u|
    uitm= Item.create(:name => "TO "+i.to_s+'-'+u.to_s, :parent => itm)
    3.times do |s|
      Slide.create(:art => "Text", :item_id => uitm.id, :name => "Slide "+i.to_s+'-'+u.to_s+"-"+s.to_s, :data => {"text" => "== TEXT \\o/"})
    end
  end
end

5.times do |p|
  Projector.create(:name => "Beamer "+p.to_s, :slide => Slide.order("RANDOM()").first)
end

5.times do |t|
  Timer.create(:name => "Timer "+p.to_s, :default => (t*15)+15, :position => (t*15)+15)
end