object @bus
attributes :id, :line_number
node do |bus|
  { :left_centroids => bus.centroids.where(:direction => false) }
end
node do |bus|
  { :right_centroids => bus.centroids.where(:direction => true) }
end
# collection :left_centroids do |u|
#   { attributes :latitude, :longitude, :catch_time }
# end

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
