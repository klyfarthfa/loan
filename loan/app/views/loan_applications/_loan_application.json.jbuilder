json.extract! loan_application, :id, :status
json.url loan_application_url(loan_application, format: :json)