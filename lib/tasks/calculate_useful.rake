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

  desc "Selecciona sapeadas utiles"
  task :calculate_usefulness => :environment do
    bus = Bus.includes(:sapeadas).find 4
    saps = bus.sapeadas
    saps.each do |sap|
      bus.stops.each do |stop|
        if Bus.geographic_distance([sap.latitude, sap.longitude], [stop.latitude, stop.longitude]) <= Bus::RADIUS
          sap.update_attributes(:useful => true)
          puts "Sapeada id #{sap.id} es util"
        else
          sap.update_attributes(:useful => false)
        end
      end
    end
  end
end