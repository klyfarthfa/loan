json.extract! loan_application, :id, :loan_amount, :prop_value, :ssn, :status, :created_at, :updated_at
json.url loan_application_url(loan_application, format: :json)