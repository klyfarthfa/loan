require 'rails_helper'

RSpec.describe "loan_applications/new", type: :view do
  before(:each) do
    assign(:loan_application, LoanApplication.new())
  end

  it "renders new loan_application form" do
    render

    assert_select "form[action=?][method=?]", loan_applications_path, "post" do
      assert_select "input#loan_application_loan_amount"
      assert_select "input#loan_application_prop_value"
      assert_select "input#loan_application_ssn"
    end
  end
end
