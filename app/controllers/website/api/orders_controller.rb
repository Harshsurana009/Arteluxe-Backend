module Website
  module Api
    # == Orders Controller
    # Provides methods to manage orders
    class OrdersController < BaseApiController
      before_action :authorize_customer
      before_action :find_order, only: %i[show add_address create_payment]

      def index
        render json: current_customer.orders, each_serializer: OrderSerializer
      end

      def show
        render json: @order, serializer: OrderSerializer
      end

      def create
        CreateOrder.call(current_customer) do
          on(:ok) { |order| render json: order, serializer: OrderSerializer }
          on(:invalid) { |errors| render json: errors, status: :unprocessable_entity }
        end
      end

      def add_address
        form = AddressForm.from_params(address_params)
        AddAddressToOrder.call(form, @order) do
          on(:ok) { |order| render json: {status: 'ok'} }
          on(:invalid) { |errors| render json: errors, status: :unprocessable_entity }
        end
      end

      def create_payment
        CreatePayment.call(@order) do
          on(:ok) { |payment| render json: payment, serializer: RazorpayPaymentSerializer }
          on(:invalid) { |errors| render json: errors, status: :unprocessable_entity }
        end
      end

      private

      def find_order
        @order = current_customer.orders.find_by!(order_ref: params[:order_ref])
      end

      def address_params
        eval(params[:data])
      end
    end
  end
end