require 'ai4r'
class Bus < ActiveRecord::Base
  serialize :centroids, Array 
  has_many :sapeadas

  def self.build_clusters(bus_id, week_day)
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
    clusters.build data_set, 2
    puts "Hecho"
    bus = Bus.find(bus_id)
    bus.update_attributes(:centroids => clusters.centroids)
    puts "Clusters guardados"
  end

end
