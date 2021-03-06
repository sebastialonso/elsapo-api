namespace :stops do
  desc "Agregar paraderos"
  task :add_stops => :environment do
    bus = Bus.find(1)
    filename = "/home/seba/sapo/backup_stops.csv"
    CSV.foreach(filename) do |row|
      s=Stop.new(:latitude => row[0], :longitude => row[1], :direction => row[2 ])
      bus.stops << s
      puts "Paradero #{s.id} guardada"
    end
  end

  desc "Tomas las sapeadas originales y las copia para cada dia"
  task :multiply_by_day => :environment do
    stops = Bus.find(1).stops
    days = [0,1,2,4,5,6]
    stops.each do |stop|
      days.each do |day|
        stop.sapeadas.where(:seed => false, :timeseed => false, :useful => true, :week_day => 3).find_each do |sap|
          new_sap = Sapeada.new(
            :stop_id => sap.stop_id,
            :bus_id => sap.bus_id,
            :latitude => sap.latitude,
            :longitude => sap.longitude,
            :week_day => day,
            :catch_time => sap.catch_time,
            :direction => sap.direction,
            :useful => sap.useful,
            :seed => true,
            :timeseed => false,
            :multiplied => sap.multiplied)
          stop.sapeadas << new_sap
        end
      end
    end
  end

  desc "Multiplica las sapeadas utiles de una parada, durante todo el dia, cada dia"
  task :multiply_all => :environment do
    #logger = Logger.new "stops_multiply.log"
    #logger.info "##############"
    #logger.info "Comenzando..."
    #logger.info "##############"
    stops = Bus.find(1).stops
    delta = 20*60
    stops.find_each do |stop|
      #logger.info "Parada #{stop.id}"
      #multiplicar cada sapeada que no haya sido multiplicada aun , y util
      #Puede ser o de las originales, o de las seed => true, que son las originales copiadas a los demas dias
      stop.sapeadas.where(:timeseed => false, :multiplied => false, :useful => true).find_each do |sap|
        kounter = 1
        new_time = sap.catch_time - kounter*delta
        #logger.info "Copiado hacia el pasado...."
        while new_time >= 23400
          new_sap = Sapeada.new(
            :stop_id => sap.stop_id,
            :bus_id => sap.bus_id,
            :latitude => sap.latitude,
            :longitude => sap.longitude,
            :week_day => sap.week_day,
            :catch_time => new_time,
            :direction => sap.direction,
            :useful => true,
            :multiplied => false,
            :seed => false,
            :timeseed => true)
          stop.sapeadas << new_sap
          kounter += 1
          new_time = sap.catch_time - kounter*delta
        end
        kounter = 1
        new_time = sap.catch_time + kounter*delta
        #logger.info "Copiado hacia el futuro...."
        while new_time <= 86400 #23:30
          new_sap = Sapeada.new(
            :stop_id => sap.stop_id,
            :bus_id => sap.bus_id,
            :latitude => sap.latitude,
            :longitude => sap.longitude,
            :week_day => sap.week_day,
            :catch_time => new_time,
            :direction => sap.direction,
            :useful => true,
            :multiplied => false,
            :seed => false,
            :timeseed => true)
          stop.sapeadas << new_sap
          kounter += 1
          new_time = sap.catch_time + kounter*delta
        end
        #ya fueron multiplicada
        sap.update_attributes(:multiplied => true)
      end
    end
  end

  desc "Multiplica por dias y cada delta minutos para una parada en especifico"
  task :multiply_by_id, [:id] => :environment do |task, args|
    logger = Logger.new "multiply_id.log"
    stop = Stop.find(args.id)
    delta = 20*60
    stop.sapeadas.where(:timeseed => false, :multiplied => false, :useful => true).find_each do |sap|
      kounter = 1
      new_time = sap.catch_time - kounter*delta
      logger.info "Copiado hacia el pasado...."
      while new_time >= 23400 #06:30
        logger.info "#{new_time}"
        new_sap = Sapeada.new(
          :stop_id => sap.stop_id,
          :bus_id => sap.bus_id,
          :latitude => sap.latitude,
          :longitude => sap.longitude,
          :week_day => sap.week_day,
          :catch_time => new_time,
          :direction => sap.direction,
          :useful => true,
          :multiplied => false,
          :seed => false,
          :timeseed => true)
        stop.sapeadas << new_sap
        kounter += 1
        new_time = sap.catch_time - kounter*delta
      end
      kounter = 1
      new_time = sap.catch_time + kounter*delta
      logger.info "Copiado hacia el futuro...."
      while new_time <= 86400 #23:30
        logger.info "#{new_time}"
        new_sap = Sapeada.new(
          :stop_id => sap.stop_id,
          :bus_id => sap.bus_id,
          :latitude => sap.latitude,
          :longitude => sap.longitude,
          :week_day => sap.week_day,
          :catch_time => new_time,
          :direction => sap.direction,
          :useful => true,
          :multiplied => false,
          :seed => false,
          :timeseed => true)
        stop.sapeadas << new_sap
        kounter += 1
        new_time = sap.catch_time + kounter*delta
      end
      #ya fueron multiplicada
      sap.update_attributes(:multiplied => true)
    end
  end
end