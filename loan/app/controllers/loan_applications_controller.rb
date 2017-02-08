class LoanApplicationsController < ApplicationController
  before_action :set_loan_application, only: [:show]

  # GET /loan_applications/1
  # GET /loan_applications/1.json
  def show
  end

  # GET /loan_applications/new
  def new
    @loan_application = LoanApplication.new
  end


  # POST /loan_applications
  # POST /loan_applications.json
  def create
    @loan_application = LoanApplication.new(loan_application_params)

    respond_to do |format|
      if @loan_application.save
        format.html { redirect_to @loan_application, notice: 'Loan application was successfully created.' }
        format.json { render :show, status: :created, location: @loan_application }
      else
        format.html { render :new }
        format.json { render json: @loan_application.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_application
      @loan_application = LoanApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_application_params
      params.require(:loan_application).permit(:loan_amount, :prop_value, :ssn)
    end
end
