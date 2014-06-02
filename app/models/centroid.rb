class Centroid < ActiveRecord::Base
  belongs_to :bus
  belongs_to :stop
end
