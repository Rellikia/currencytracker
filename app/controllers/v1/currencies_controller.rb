class V1::CurrenciesController < V1::ApiController
  before_action :set_currency, only: [:show]

  # GET /v1/currencies
  def index
    @currencies = Currency.all.includes(:exchanges, :price).order :created_at

    render json: @currencies
  end

  # GET /v1/currencies/1
  def show
    if @currency
      render json: @currency
    else
      render status: 404, json: {error: :currency_not_found}.to_json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:uuid]) if params[:uuid]
    end
end
