module Website
  module Api
    # == Address Form
    # Provides methods to manage address form
    class AddressForm < Rectify::Form
      attribute :city, String
      attribute :state, String
      attribute :country, String
      attribute :address, String
      attribute :zip_code, String

      validates :city, :state, :country, :address, :zip_code, presence: true
    end
  end
end