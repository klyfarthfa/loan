require 'test_helper'

class LoanApplicationsControllerTest < ActionController::TestCase
  setup do
    @loan_application = loan_applications(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create loan_application" do
    assert_difference('LoanApplication.count') do
      post :create, loan_application: { loan_amount: @loan_application.loan_amount, prop_value: @loan_application.prop_value, ssn: @loan_application.ssn, status: @loan_application.status }
    end

    assert_redirected_to loan_application_path(assigns(:loan_application))
  end

  test "should show loan_application" do
    get :show, id: @loan_application
    assert_response :success
  end

end
