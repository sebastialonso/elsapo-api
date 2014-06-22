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
    logger = Logger.new "sapeada_usefulness.log"
    logger.info Time.now.in_time_zone
    bus = Bus.find 1
    #saps = bus.sapeadas
    #Si para algun paradero, la sapeada se encuentra en su radio, entonces nos sirve
    Sapeada.where(:bus_id => bus.id).find_each do |sap|
      bus.stops.each do |stop|
        if sap.useful.nil? or not sap.useful
          if sap.direction == stop.direction and Bus.geographic_distance([sap.latitude.to_f, sap.longitude.to_f], [stop.latitude, stop.longitude]) <= Bus::RADIUS
            sap.update_attributes(:useful => true, :stop_id => stop.id)
            stop.sapeadas << sap
            logger.info "Yay, sapeada #{sap.id} es util"
          end
        end
      end
    end
  end

  desc "Copia las sapeadas de un día a otro dia"
  task :multiplicar_en_dias => :environment do
    days = [0,1,2,4,5,6]
    days.each do |week_day|
      Sapeada.where(:bus_id => 1, :week_day => 3).find_each do |sap|
        new_sap = Sapeada.new
        new_sap.bus_id = sap.bus_id
        new_sap.stop_id = sap.stop_id
        new_sap.latitude = sap.latitude
        new_sap.longitude = sap.longitude
        new_sap.useful = sap.useful
        new_sap.catch_time = sap.catch_time
        new_sap.week_day = week_day
        new_sap.direction = sap.direction
        new_sap.seed = true
        new_sap.save
      end
      puts "day #{week_day} done"
    end
  end

  require 'csv'
  desc "Copia sapeadas desde archivo CSV"
  task :from_csv => :environment do
    filename = "/home/seba/sapo/backup_sapeadas_original.csv"
    CSV.foreach(filename) do |row|
      #Sin utilidad, debe ser calculada
      sap = Sapeada.new(
        :bus_id => row[1],
        :latitude => row[2],
        :longitude => row[3],
        :week_day => row[4],
        :catch_time => row[5],
        :direction => row[8],
        :useful => false,
        :seed => row[10],
        :timeseed => row[11])
      sap.save
    end
    puts "Sapeadas importadas desde #{filename}"
  end
end