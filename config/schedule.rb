# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every 1.days, :at => "11:15 pm" do
  d= Time.now.in_time_zone.wday
  b = Bus.find(4)
  #tanto clusters como paraderos en direccion false
  k = b.stops.where(:direction => false).size
  runner "Bus.build_clusters(4,#{d}, #{false}, #{k})"
end

# Learn more: http://github.com/javan/whenever
