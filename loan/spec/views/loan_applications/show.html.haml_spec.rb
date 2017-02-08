require 'rails_helper'

RSpec.describe "loan_applications/show", type: :view do
  before(:each) do
    @loan_application = assign(:loan_application, LoanApplication.create!({loan_amount: 50000, prop_value: 5000, ssn: "555158423"}))
  end

  it "renders id and status" do
    render

    assert_select "dl.dl-horizontal" do
      assert_select "dt", 2
      assert_select "dd", 2
    end
  end
end
