class SapeadasController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json
  after_filter :set_access_control_headers

  def index
    @sapeadas = Sapeada.where(:bus_id => params[:bus_id])
  end

  def options
    if access_allowed?
      set_access_control_headers
      head :ok
    else
      head :forbidden
    end
  end
  
  def create
    respond_to do |format|
      puts "INCOMIIIIIIIIIIIIIIIIING"
      @sapeada = Sapeada.new sapeada_params
      @sapeada.catch_time = date_to_seconds sapeada_params[:catch_time]
      
      #Guardamos si la sapeada está dentro del radio de algun paradero
      bus = Bus.find(sapeada_params[:bus_id])
      @sapeada.useful = false
      bus.stops.each do |stop|
        if (stop[0] - @sapeada.latitude)**2 + (stop[1] - @sapeada.longitude)**2 < 3e-5
          puts "ZONA de PARADERO"
          @sapeada.useful = true    
          break
        end
      end 
      #Se guarda
      if @sapeada.save
        format.json { render 'success' }
      else
        format.json { render 'error' }
      end
    end
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

    def sapeada_params
      params.require(:sapeada).permit(:bus_id, :latitude, :longitude, :week_day, :catch_time, :direction)
    end

    def date_to_seconds(date)
      date = date.to_datetime
      date.hour*60*60 + date.min*60 + date.sec
    end
end
