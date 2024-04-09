# frozen_string_literal: true

module Website
  module Api
    # == Autheticate customer
    # Service class written for customer authetication.
    # It will check for customer credentials and the Token will be generated
    # also sign in count and last sign at deatils will be updated.
    class AuthenticateCustomer < Rectify::Command
      def initialize(email, password)
        @email = email
        @password = password
      end

      # service entry point
      def call
        check_required_params
        customer = find_and_authenticate_customer
        access_token = generate_token(customer)

        broadcast(:ok, { access_token: access_token })
      end

      private

      attr_reader :email, :password

      def check_required_params
        blank_required_fields = []
        blank_required_fields << 'email' if email.blank?
        blank_required_fields << 'password' if password.blank?
        broadcast(:required_fields_missing, blank_required_fields) if blank_required_fields.present?
      end

      def token_expiry
        7.days.freeze
      end

      def generate_token(customer)
        payload = { customer_id: customer.id }
        JsonWebToken.encode_token(payload, Time.zone.now + token_expiry)
      end

      def find_and_authenticate_customer
        customer = Customer.find_by('lower(email) = lower(?)', email)
        broadcast(:invalid_credentials) unless customer.present? && customer.authenticate(password)

        customer
      end
    end
  end
end
