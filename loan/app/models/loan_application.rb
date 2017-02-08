class LoanApplication < ActiveRecord::Base
  VALID_STATUSES = ["accepted", "rejected"]
  validates :loan_amount, :prop_value, :ssn, presence: true
  validates :loan_amount, :prop_value, numericality: true
  validates :status, inclusion: { in: VALID_STATUSES, allow_blank: true }
  
  before_save :set_status

  def set_status
    #Using multiplication instead of division avoids dbz errors
    self.status = (loan_amount > 0.4 * prop_value) ? "rejected" : "accepted"
  end
end
