require 'paystack'
# require 'dotenv/load'

class CheckoutsController < ApplicationController

  def create
    # paystack_secret_key = Rails.application.credentials.dig(:paystack, :secret_key)
    # path_to_cacert = File.join(Rails.root, 'config', 'certificates', 'cacert.pem') 


    cart = params[:cart]
    if cart.blank? 
      logger.error("Cart is empty or missing.")
      render json: { error: "Your cart is empty" }, status: 400 # Or redirect to cart page
      return
    end 

    begin
      # line_items = cart.map do |item| # Use the cart array from set_cart
      #   product = Product.find(item["id"])
      #   product_stock = product.product_stocks.find{ |ps| ps.size ==  item["size"].to_i}

      #   if product_stock.quantity < item["quantity"].to_i
      #     render json: { error: "Not enough stock for #{product.name}"},  status: 400
      #     return
      #   end
      #   {
      #     name: product.name,
      #     amount: product.price * 100, # Paystack expects amount in kobo
      #     quantity: item["quantity"].to_i ,
      #     metadata: { product_id: product.id, size: item["size"].to_i, product_stock_id: product_stock.id}
      #   }
      # end

    #   paystack = Paystack.new(ENV['PAYSTACK_PUBLIC_KEY'], ENV['PAYSTACK_PRIVATE_KEY'])
    #   logger.debug("Paystack Secret Key: #{ENV['PAYSTACK_SECRET_KEY']}") # Add this line
    #   logger.debug("Paystack Object Created: #{paystack.inspect}")
    #   transactions = PaystackTransactions.new(paystack)

    #   payment_response = PaystackTransactions.initializeTransaction(paystack,
    #   reference: generate_reference, 
    #   # email: current_admin.email, 
    #   amount: calculate_total(line_items) * 100, 
    #    metadata: { cart: line_items },
    #   callback_url: success_callback 
    # )
      # logger.debug("Paystack response status: #{payment_response.status}")


      # if payment_response.status
      #   redirect_to payment_response.authorization_url
      # else
      #   logger.debug("Paystack initialization failed, response: #{payment_response.inspect}")
      #   raise "Paystack Error: #{payment_response.inspect}" 
      # end

    rescue => error
      # logger.error "Error during Paystack checkout: #{error.class} - #{error.message}"
      # logger.error "Paystack API Response: #{error.response.inspect}" if error.respond_to?(:response)
      # render json: { error: "An error occurred while processing your payment" }, status: 500
      # render json: { status: 'success' } # Replace with your desired JSON response 
      # redirect_to cart_path, alert: "An error occurred while processing your payment."
      # logger.error "Paystack Error: #{error.class} - #{error.message}" 
    end
  end

  def success_callback
    # RestClient.ssl_ca_file = File.join(Rails.root, 'config', 'certificates', 'cacert.pem') 
    # # 1. Verify payment reference with Paystack
    # transaction_ref = params[:trxref]
    # paystack = Paystack.new(ENV['PAYSTACK_PUBLIC_KEY'], ENV['PAYSTACK_PRIVATE_KEY']) 
    # # transactions = PaystackTransactions.new(paystack) 
    # response = PaystackTransactions.verify(paystack, transaction_ref) 

    # if response.status
    # # Find the corresponding order
    # order = Order.find_by(transaction_reference: transaction_ref) 
    #   if order
    #     order.update(status: :paid)
    #     # ... update inventory based on order.metadata  
    #     current_user.cart.clear  # Assuming 'current_user' represents the logged-in user
    #     redirect_to order_confirmation_path(order), notice: "Your transaction was successful!  Your cart has been cleared."
    #   else
    #     # Handle case where the corresponding order is not found
    #     logger.error "Order not found for transaction reference: #{transaction_ref}"
    #     redirect_to root_path, alert: "Payment verification error. Please contact support."
    #   end
    # else
    #   # Handle unsuccessful payment
    #   redirect_to orders_path, alert: "Payment failed. Please try again."
    # end
  end

  def success
    render :success
  end

  def cancel
    render :cancel
  end

  def generate_reference
    SecureRandom.uuid
  end

  private

  def set_cart
    @cart = JSON.parse(params[:cart])
  end

  def calculate_total(line_items)
    total_price = 0
    line_items.each do |item|
      total_price += item["price"].to_i * item["quantity"].to_i
    end
    total_price
  end

end
