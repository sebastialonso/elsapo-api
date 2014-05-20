object @bus
attributes :id, :line_number
child(:stops){ attributes :latitude, :longitude, :direction}
child(:right_centroids){ attributes :latitude, :longitude, :catch_time }
child(:left_centroids){ attributes :latitude, :longitude, :catch_time }
