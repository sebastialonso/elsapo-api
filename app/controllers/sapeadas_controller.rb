class SapeadasController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json
  after_filter :set_access_control_headers

  def index
    @sapeadas = Sapeada.all  
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
      if @sapeada.save
        format.json { render 'success' }
        #render json: @sapeada, success: true, status: :created
      else
        format.json { render 'error' }
        #render json: resources.errors, status: :unprocessable_entity
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
