# frozen_string_literal: true

module Website
  module Api
    # == Base API Controller for website
    # rest all controller will be inherited from this controller.
    class BaseApiController < ActionController::API
      include Rectify::ControllerHelpers

      def authorize_customer
        AuthorizeCustomer.call(request.headers) do
          on(:customer) { |customer| expose(current_customer: customer) }
          on(:token_missing) do
            raise 'Access Token missing'
          end
          on(:token_expired) do
            raise 'Access Token expired'
          end
        end
        @current_customer
      end

      def find_cart
        @cart ||= @current_customer.cart
      end

      # it return the logged-in customer object
      def current_customer
        @current_customer
      end

      def cart
        @cart
      end
    end
  end
end
