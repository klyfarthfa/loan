class LoanApplication < ActiveRecord::Base
  VALID_STATUSES = ["accepted", "rejected"]
  validates :loan_amount, :prop_value, :ssn, presence: true
  validates :loan_amount, :prop_value, numericality: true
  validates :status, inclusion: { in: VALID_STATUSES, allow_blank: true }
  validates :ssn, length: { is: 9 }
  validate :ssn_is_valid
  
  before_save :set_status
  before_validation :clean_ssn

  def set_status
    #Using multiplication instead of division avoids dbz errors
    self.status = (loan_amount > 0.4 * prop_value) ? "rejected" : "accepted"
  end

  def clean_ssn
    self.ssn = self.ssn.gsub(/\D/,'') if ssn.present?
  end

  def ssn_is_valid
    return unless self.ssn.present?
    errors.add(:ssn, "is a fake ssn") if ["078051120", "219099999"].include? self.ssn
    first_three = self.ssn[0,3]
    second_two = self.ssn[3,2]
    third_four = self.ssn[5,4]
    
    if first_three == "000" || ((900...999).to_a + [666]).include?(first_three.to_i) ||
      second_two == "00" || third_four == "0000"
      errors.add(:ssn, "is invalid")
    end
    


  end
end
