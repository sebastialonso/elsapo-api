namespace :stops do
  desc "Agregar paraderos"
  task :add_stops => :environment do
    stops_to_add = [[-33.040433, -71.590451, true],
    [-33.036030, -71.592669, true],
    [-33.036884, -71.595815, true],
    [-33.034192, -71.595658, true],
    [-33.033172, -71.591629, true],
    [-33.029466, -71.586667, true],
    [-33.027493, -71.575485, true],
    [-33.024122, -71.566621, true]]
    bus = Bus.find(1)
    stops_to_add.each do |stop|
      new_stop = Stop.new(:latitude => stop[0], :longitude => stop[1], :direction => stop[2])
      new_stop.buses << bus
    end
  end
end