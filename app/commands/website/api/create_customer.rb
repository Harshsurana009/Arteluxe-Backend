# frozen_string_literal: true

module Website
  module Api
    # == CreateCustomer
    # Service class written for creating the customer
    class CreateCustomer < Rectify::Command
      def initialize(customer_form)
        @customer_form = customer_form
      end

      # service entry point
      def call
        # checks if form object is valid, if not broadcasts :invalid
        check_if_form_valid
        transaction do
          @customer = create_customer
          # temp remove later we decide about when to sent this email
          # send_confirmation_email(@customer)
        end
        broadcast(:ok, @customer)
      end

      private

      attr_reader :customer_form

      def create_customer
        Customer.create!(customer_form.to_h)
      end

      def check_if_form_valid
        broadcast(:invalid, customer_form.errors.messages) if customer_form.invalid?
      end
    end
  end
end
