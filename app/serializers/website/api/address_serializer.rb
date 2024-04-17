module Website
  module Api
    # == Address Serializer
    # Provides methods to serialize address
    class AddressSerializer < ActiveModel::Serializer
      attributes :city, :state, :country, :address, :zip_code, :complete_address
    end
  end
end