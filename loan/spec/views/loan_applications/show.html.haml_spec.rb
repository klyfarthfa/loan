require 'rails_helper'

RSpec.describe "loan_applications/show", type: :view do
  before(:each) do
    @loan_application = assign(:loan_application, LoanApplication.create!({loan_amount: 50000, prop_value: 5000, ssn: "555158423"}))
  end

  it "renders attributes in <p>" do
    render
  end
end
