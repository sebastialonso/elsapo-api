require 'ai4r'
class Bus < ActiveRecord::Base
  RADIUS = 2.5e-6
  serialize :centroids, Array 
  serialize :stops, Array
  has_many :sapeadas

  def self.build_clusters(bus_id, week_day, k)
    sapeadas = Sapeada.where(:bus_id => bus_id, :week_day => week_day)
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
    puts "Calculando clusters..."
    clusters = Ai4r::Clusterers::KMeans.new
    clusters.build data_set, k
    puts "Hecho"
    bus = Bus.find(bus_id)
    bus.update_attributes(:centroids => clusters.centroids)
    puts "Clusters guardados"
  end

  def find_best_clusters(lat,long, catch_time)
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
