require 'ai4r'
class Bus < ActiveRecord::Base
  RADIUS = 1.9e-6
  has_many :sapeadas
  has_and_belongs_to_many :stops
  has_many :left_centroids, class_name: "Centroid", lambda -> { where direction: false }
  has_many :right_centroids, class_name: "Centroid",  lambda -> { where direction: true }

  def self.build_clusters(bus_id, week_day, k, direction)
    sapeadas = Sapeada.where(:bus_id => bus_id, :week_day => week_day, :useful => true, :direction => direction)
    saps_array = []
    sapeadas.each do |sap|
      new_data = []
      new_data.append sap.latitude
      new_data.append sap.longitude
      new_data.append sap.catch_time
      saps_array.append new_data
    end
    data_labels = ['latitude', 'longitude', 'catch_time']
    data_set = Ai4r::Data::DataSet.new(:data_items => saps_array, :data_labels => data_labels)
    puts "Calculando..."
    clusters = Ai4r::Clusterers::KMeans.new
    clusters.build data_set, k
    puts "Hecho"
    puts "Creando clusters..."
    centroids_to_add_to_bus = Centroid.limit 0
    clusters.centroids.each do |centroid|
      cent = Centroid.create(
        :latitude => centroid[0].to_d,
        :longitude => centroid[1].to_d,
        :catch_time => centroid[2],
        :direction => direction,
        :bus_id => bus_id
        )
      centroids_to_add_to_bus.append cent
    end
    bus = Bus.find(bus_id)
    if direction #true -> vina -> clusters derechos
      bus.update_attributes(:right_centroids => centroids_to_add_to_bus)
      puts "derechos"
    else
      bus.update_attributes(:left_centroids => centroids_to_add_to_bus)
      puts "izquierdos"
    end
    if direction
      direction_st = "derechos"
    else
      direction_st = "izquierdos"
    end
    puts "Clusters #{direction_st} guardados"
  end

  def find_best_clusters(lat,long, catch_time, direction, week_day)
    max = Float::INFINITY
    sel_index = 0
    centroids.each_with_index do |cluster, index|
      if Bus.distance(cluster, [lat,long, catch_time]) < max
        sel_index = index
      end
    end
    centroids[sel_index]
  end

  def self.geographic_distance(point_1, point_2)
    (point_1[0] - point_2[0])**2 + (point_1[1] - point_2[1])**2 
  end

  def self.distance(cluster, data)
    (cluster[0] - data[0].to_i)**2 + (cluster[1] - data[1].to_i)**2 + (cluster[2] - data[2].to_i)**2
  end

end
