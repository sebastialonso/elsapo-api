collection @sapeadas => :sapeadas
attribute :id, :bus_id, :latitude, :longitude, :week_day, :catch_time, :direction
node :saved_time do |sap|
  created_time = sap.created_at.in_time_zone
  created_time.hour*60*60 + created_time.min*60 + created_time.sec
end