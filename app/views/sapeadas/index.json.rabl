collection @sapeadas => :sapeadas
attribute :id, :bus_id, :latitude, :longitude, :week_day, :catch_time
node :creado_a_las do |sap|
  sap.created_at.in_time_zone
end