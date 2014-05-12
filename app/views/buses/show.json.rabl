object @bus
attributes :id, :line_number
child(:stops){ attributes :latitude, :longitude, :direction}
