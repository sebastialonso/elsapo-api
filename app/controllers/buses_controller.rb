class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.all
  end

  def predict
    bus = Bus.find(params[:bus_id])
    @predict = bus.find_best_clusters(params[:latitude], params[:longitude], params[:catch_time])
  end

  def last
    @sapeada = Sapeada.where(:bus_id => params[:bus_id]).last
  end

end
