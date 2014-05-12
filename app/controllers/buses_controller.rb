class BusesController < ApplicationController
  respond_to :json

  def index
    @buses = Bus.all
  end

  def show
    @bus = Bus.find params[:id]
  end

  def predict
    bus = Bus.find(params[:bus_id])
    @predict = bus.find_best_clusters(params[:latitude], params[:longitude], params[:catch_time])
    puts "PREDIIIIIIIIIIIIIIIIIIIIIIICT"
    puts @predict
    if @predict.size > 1
      @predict.first
    else
      @predict
    end
  end

  def last
    @sapeada = Sapeada.where(:bus_id => params[:bus_id]).last
  end

end
