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
    #Si para algun paradero, la sapeada se encuentra en su radio, entonces nos sirve
    saps.each_with_index do |sap, sap_index|
      bus.stops.each_with_index do |stop, stop_index|
        if sap_index == 4022
          puts "distancia entre puntos: #{Bus.geographic_distance([sap.latitude, sap.longitude], stop)}"
          puts "debe ser menor que: #{Bus::RADIUS}"
          puts "#{Bus.geographic_distance([sap.latitude, sap.longitude], stop) <= Bus::RADIUS}"
        end
        if Bus.geographic_distance([sap.latitude, sap.longitude], stop) <= Bus::RADIUS
          sap.update_attributes(:useful => true)
          if sap_index == 4022
            puts "es util la sapeada 4022: #{sap.useful}"
          end
        else
          sap.update_attributes(:useful => false)
        end
      end
    end
  end
end