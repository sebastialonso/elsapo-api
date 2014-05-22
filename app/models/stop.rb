class Stop < ActiveRecord::Base
  has_and_belongs_to_many :buses
  has_many :sapeadas
end
