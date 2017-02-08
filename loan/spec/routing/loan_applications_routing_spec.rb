require "rails_helper"

RSpec.describe LoanApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/loan_applications/new").to route_to("loan_applications#new")
    end

    it "routes to #show" do
      expect(:get => "/loan_applications/1").to route_to("loan_applications#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/loan_applications").to route_to("loan_applications#create")
    end
  end
end
