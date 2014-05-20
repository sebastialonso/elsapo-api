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
    bus = Bus.includes(:sapeadas).find 1
    saps = bus.sapeadas
    #Si para algun paradero, la sapeada se encuentra en su radio, entonces nos sirve
    saps.each_with_index do |sap, sap_index|
      bus.stops.each_with_index do |stop, stop_index|
        if sap.useful.nil? or not sap.useful
          if sap.direction == stop.direction and Bus.geographic_distance([sap.latitude.to_f, sap.longitude.to_f], [stop.latitude, stop.longitude]) <= Bus::RADIUS
            sap.update_attributes(:useful => true)
            logger.info "Yay, sapeada #{sap.id} es util"
          end
        end
      end
    end
  end

  desc "Copia las sapeadas de un día a otro dia"
  task :multiplicar_en_dias => :environment do
    days = [0,1,2,4,5,6]
    sapeadas = Sapeada.where(:bus_id => 1, :week_day => 3)
    days.each do |week_day|
      sapeadas.each do |sap|
        new_sap = Sapeada.new
        new_sap.bus_id = sap.bus_id
        new_sap.latitude = sap.latitude
        new_sap.longitude = sap.longitude
        new_sap.useful = sap.useful
        new_sap.catch_time = sap.catch_time
        new_sap.week_day = week_day
        new_sap.seed = true
        new_sap.save
      end
      puts "day #{week_day} done"
    end
  end

  require 'csv'
  desc "Copia sapeadas desde archivo CSV"
  task :from_csv => :environment do
    filename = Rails.root.join("sapeadas.csv")
    CSV.foreach(filename) do |row|
      sap = Sapeada.new(
        :bus_id => 1,
        :latitude => row[2].to_d,
        :longitude => row[3].to_d,
        :week_day => 3,
        :catch_time => row[5],
        :direction => row[8]
        )
      sap.save
    end
    puts "Sapeadas importadas desde #{filename}"
  end

  desc "Multiplicar cada 20 minutos"
  task :new_every_20_minutes => :environment do
    delta = 20*60
  end
end