namespace :sapeadas do 
  desc "Mueve sapeadas utiles de bus 1 a 4"
  task :assign_to_marcha_blanca => :environment do
    saps = Sapeada.where(:week_day => 3, :bus_id => 1).where.not(:direction => nil)
    target = Bus.find 4
    saps.each do |sap|
      s = Sapeada.new
      s.bus_id = 4
      s.latitude = sap.latitude
      s.longitude = sap.longitude
      s.catch_time = sap.catch_time
      s.week_day = sap.week_day
      s.direction = sap.direction
      s.save
    end
  end
end