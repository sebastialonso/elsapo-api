object @bus
attributes :id, :line_number
child :left_centroids { attributes :latitude, :longitude, :catch_time }
# node :right_centroids do |bus|
#   bus.right_centroids
# end
child(:stops){ attributes :latitude, :longitude, :direction}
# node :left_centroids do |bus|
#   bus.left_centroids
# end
#child(:right_centroids){ attributes :latitude, :longitude, :catch_time, :direction }
# node :right_centroids do |bus|
#   bus.right_centroids
# end
# node do |bus|
#   { :centroids => bus.centroids }
# end
# node :centroids do |bus|
#   bus.centroids.each do |centroid|
#     centroid.centroids[0], centroid.centroids[1], centroid.centroids[2] 
#   end
# end
