json.extract! customer, :id, :name, :birthday, :sex, :address, :created_at, :updated_at
json.url customer_url(customer, format: :json)
