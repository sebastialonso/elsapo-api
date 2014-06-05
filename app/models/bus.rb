require 'ai4r'
class Bus < ActiveRecord::Base
  RADIUS = 1.9e-6
  has_many :sapeadas
  has_and_belongs_to_many :stops
  has_many :centroids

  def right_centroids
    centroids.where(:direction => true)
  end

  def left_centroids
    centroids.where(:direction => false)
  end

  def self.build_all_clusters(bus_id, week_day)
    start = Time.now
    bus = Bus.find bus_id
    #bus.centroids.clear
    bus.stops.find_each do |stop|
      #Es crucial borrar los centroides anteriores antes de reemplazarlos
      stop.centroids.clear
      Bus.build_clusters(stop, week_day, bus_id)
    end
    puts "Resultado total: #{Time.now - start}"
  end

  def self.build_clusters(stop_to_predict, week_day, bus_id)
    start = Time.now
    bus = Bus.find(bus_id)
    sapeadas = Sapeada.where(:bus_id => bus_id, :week_day => week_day, :useful => true, :direction => stop_to_predict.direction, :stop_id => stop_to_predict.id).pluck(:catch_time)
    k = 50
    saps_array = []
    sapeadas.each do |time|
      # new_data = []
      # new_data.append sap.catch_time
      saps_array.append [time]
    end
    data_labels = ['catch_time']
    data_set = Ai4r::Data::DataSet.new(:data_items => saps_array, :data_labels => data_labels)
    puts "Calculando... con #{saps_array.size} sapeadas y con k=#{k}"
    clusters = Ai4r::Clusterers::KMeans.new
    clusters.build data_set, k
    #puts "Hecho"
    #puts "Creando clusters..."
    #centroids_to_add_to_bus = Centroid.limit 0
    clusters.centroids.each do |centroid|
      cent = Centroid.new(
        :latitude => stop_to_predict.latitude,
        :longitude => stop_to_predict.longitude,
        :catch_time => centroid[0],
        :direction => stop_to_predict.direction,
        :stop_id => stop_to_predict.id
        )
      #centroids_to_add_to_bus.append cent
      stop_to_predict.centroids << cent
    end
    puts "Resultado parcial para paradero #{stop_to_predict.id}:  #{Time.now - start}"
  end

  #Modify this to work for every day, every direction
  def find_best_clusters(lat,long, catch_time, direction, week_day)
    temporal_delta = 600
    #max = Float::INFINITY
    max = BigDecimal::INFINITY
    near_stop = nil

    #Analisis geografico
    stops.where(:direction => direction).each_with_index do |stop, index|
      candidate = Bus.geographic_distance([stop.latitude, stop.longitude], [lat,long])
      if candidate < max
        near_stop = stop
        max = candidate
      end
    end

    #Analisis temporal, para el paradero seleccionado
    max_time = Float::INFINITY
    best_guess = nil
    near_stop.centroids.where(:direction => direction).each do |centroid|
      candidate = Bus.temporal_distance(centroid.catch_time, catch_time.to_i)
      if candidate < max_time and centroid.catch_time > catch_time.to_i
        best_guess = centroid
        max_time = candidate 
      end
    end
    #se mapea la resta a todas las filas
    #time_data = time_data.map {|z| z - catch_time.to_i }

    #Donde la diferencia de tiempo sea mayor que 0 (no haya pasado aun) y sea mas grande de un minuto
    #time_data = time_data.sort.find{|x| x > 0 && x > 60 }

    #Si no encuentras recomendaciones, te pasaste del limite y te recomiendo la que pasa mas temprano
    if best_guess.nil? or best_guess.blank?
      best_guess = Sapeada.where(:stop_id => near_stop.id, :direction => direction, :bus_id => 1, :week_day => week_day).order("catch_time ASC").first
    end
    [near_stop.latitude, near_stop.longitude, best_guess.catch_time - catch_time.to_i]
  end

  def self.geographic_distance(point_1, point_2)
    (point_1[0] - point_2[0].to_d)**2 + (point_1[1] - point_2[1].to_d)**2 
  end

  def self.temporal_distance(point_1,point_2)
    (point_1 - point_2)**2
  end

  def self.distance(cluster, data)
    (cluster[0] - data[0].to_d)**2 + (cluster[1] - data[1].to_d)**2 + (cluster[2] - data[2].to_i)**2
  end
end
