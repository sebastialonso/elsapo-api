object @bus
attributes :id, :line_number
child :stops 
  attributes :latitude, :longitude, :direction
  child :centroids do
    attribute :catch_time
# child :right_centroids => :right_centroids  do
#   attributes :latitude, :longitude, :catch_time
# end
# child :left_centroids => :left_centroids do
#   attributes :latitude, :longitude, :catch_time
# end

