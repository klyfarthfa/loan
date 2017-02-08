require 'rails_helper'

RSpec.describe "loan_applications/show", type: :view do
  before(:each) do
    @loan_application = assign(:loan_application, LoanApplication.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
