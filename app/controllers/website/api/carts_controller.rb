module Website
  module Api
    # == Carts Controller
    # Provides methods to manage cart
    class CartsController < BaseApiController
      before_action :authorize_customer, :find_cart

      def show
        render json: cart, serializer: CartSerializer
      end

      def add_to_cart
        existing_cart_product = cart.items.find_by(product_id: cart_params[:product_id])

        if existing_cart_product
          existing_cart_product.update(quantity: existing_cart_product.quantity + cart_params[:quantity].to_i)
        else
          cart.items.create(product_id: cart_params[:product_id], quantity: 1)
        end

        render json: cart, serializer: CartSerializer
      end

      def remove_from_cart
        cart.items.find_by(product_id: cart_params[:product_id])&.destroy
        render json: cart, serializer: CartSerializer
      end

      private

      def cart_params
        params.permit(:product_id, :quantity)
      end
    end
  end
end
