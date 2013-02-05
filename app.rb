require "sinatra"
require "braintree"

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "dx9t6w6jysmmzx96"
Braintree::Configuration.public_key = "sgkc7ynt752qkb4y"
Braintree::Configuration.private_key = "241b1cf58fd26b57bf09efa620857125"

get '/' do
  tr_data = Braintree::TransparentRedirect.transaction_data(
      :redirect_url => "http://localhost:9393/braintree",
      :transaction => {
        :type => "sale",
        :amount => "1.00"
      }
  )

  erb :form, :locals => {:tr_data => tr_data}
end


get "/braintree" do
  result = Braintree::TransparentRedirect.confirm(request.query_string)

  if result.success?
    message = "Transaction Status: #{result.transaction.status}"
    # status will be authorized or submitted_for_settlement
  else
    message = "Message: #{result.message}"
  end

  erb :response, :locals => {:message => message}
end

get '/customer' do
	tr_data = Braintree::TransparentRedirect.create_customer_data(
    :redirect_url => "http://localhost:9393/create_customer"
    )

  erb :customer, :locals => {:tr_data => tr_data}
end

get '/create_customer' do
	result = Braintree::TransparentRedirect.confirm(request.query_string)

  if result.success?
    message = "Customer Created with the email: #{result.customer.email}"
  else
    message = "Message: #{result.message}"
  end

  erb :response, :locals => {:message => message}
end