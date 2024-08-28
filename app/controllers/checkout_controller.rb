class CheckoutController < ApplicationController
  def create
    product = Product.find_by(id: params[:product_id])

    if product.nil?
      redirect_to root_path, alert: "Product not found."
      return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: [ {
        price_data: {
          currency: "usd",
          product_data: {
            name: product.name
          },
          unit_amount: product.price
        },
        quantity: 1
      } ],
      mode: "payment",
      success_url: root_url,
      cancel_url: root_url
    )

    redirect_to session.url, allow_other_host: true
  end
end
