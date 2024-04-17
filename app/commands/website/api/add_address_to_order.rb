module Website
  module Api
    # == Add Address To Order
    # Service object to add address to order
    class AddAddressToOrder < Rectify::Command
      def initialize(form, order)
        @form = form
        @order = order
      end

      def call
        return broadcast(:invalid, @form.errors) if @form.invalid?

        transaction do
          @order.create_address!(address_params)
          broadcast(:ok, @order)
        end
      end

      private

      def address_params
        {
          resource: @order.customer,
          city: @form.city,
          state: @form.state,
          country: @form.country,
          address: @form.address,
          zip_code: @form.zip_code
        }
      end
    end
  end
end