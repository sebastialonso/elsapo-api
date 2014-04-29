object @bus
node(:bus_id) { @bus.id }
node(:latitude) { 
  if @bus.id == 3
    "-33.031132" 
  elsif @bus.id == 2
    "-33.039556"
  else
    "00.000000"
  end 
}
node(:longitude) { 
  if @bus.id == 3
    "-71.543712" 
  elsif @bus.id == 2
    "-71.593878"      
  else
    "00.000000"
  end
}
node(:catch_time) { 84600 }