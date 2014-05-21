class BusesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json
  after_filter :set_access_control_headers

  # def options
  #   if access_allowed?
  #     set_access_control_headers
  #     head :ok
  #   else
  #     head :forbidden
  #   end
  # end

  def index
    @buses = Bus.all
  end

  def show
    @bus = Bus.find params[:id]
  end

  def predict
    bus = Bus.find(1)
    @predict = bus.find_best_clusters(params[:latitude], params[:longitude], params[:catch_time], params[:direction], params[:week_day])
    bus.centroids.first
  end

  def last
    @sapeada = Sapeada.where(:bus_id => params[:bus_id], :direction => params[:direction]).order("created_at DESC").first
  end

  private
    def set_access_control_headers
      headers['Access-Control-Allow-Origin'] = "*"
      headers['Access-Control-Request-Methods'] = 'POST, GET, OPTIONS'
    end

    def access_allowed?
      allowed_sites = [request.env['HTTP_ORIGIN']]
      return allowed_sites.include?(request.env['HTTP_ORIGIN'])
    end
end
