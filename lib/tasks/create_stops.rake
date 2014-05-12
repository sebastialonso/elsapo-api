namespace :buses do
  desc "Toma las stops de Bus id 4 y los transforma en Stops"
  task :create_stops => :environment do
    bus = Bus.find(4)
    puts "bus paradas #{bus.paradas}"
    bus.paradas.each do |parada|
      puts "This round: #{parada}"
      puts "los campos son #{parada[0].class}"
      stop = Stop.new(:latitude => parada[0], :longitude => parada[1])
      stop.save
      bus.stops << stop
    end
  end
end