object @bus
attributes :id

child :sapeadas => :sapeadas do
attribute :bus_id, :latitude, :longitude, :sapeada_time, :week_day
end