require "rails_helper"

RSpec.describe V1::CurrenciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/v1/currencies").to route_to("v1/currencies#index")
    end


    it "routes to #show" do
      expect(:get => "/v1/currencies/1").to route_to("v1/currencies#show", :id => "1")
    end

  end
end
