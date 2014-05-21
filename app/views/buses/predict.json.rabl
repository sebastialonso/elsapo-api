object false
node(:latitude) { |m| @predict.latitude }
node(:longitude) { |m| @predict.longitude }
node(:catch_time) { |m| @predict.catch_time }
#attributes {:latitude, :longitude, :catch_time}
# node :latitude do |prediction|
#   prediction.latitude
# end
# node(:longitude){ @predict[1] }
# node(:catch_time){ @predict[2] }
# node(:bus_id) { @bus.id }
# node(:latitude) { 
#   if @bus.id == 3
#     "-33.031132" 
#   elsif @bus.id == 2
#     "-33.039556"
#   else
#     "00.000000"
#   end 
# }
# node(:longitude) { 
#   if @bus.id == 3
#     "-71.543712" 
#   elsif @bus.id == 2
#     "-71.593878"      
#   else
#     "00.000000"
#   end
# }
# node(:catch_time) { 84600 }