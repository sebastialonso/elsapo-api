object @bus
attributes :id, :line_number
child(:stops){ attributes :latitude, :longitude, :direction}
node do |bus|
  { :centroids => bus.centroids }
end
# node :centroids do |bus|
#   bus.centroids.each do |centroid|
#     centroid.centroids[0], centroid.centroids[1], centroid.centroids[2] 
#   end
# end
