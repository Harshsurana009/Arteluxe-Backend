module Website
  module Api
    class CustomerSerializer < ActiveModel::Serializer
      attributes :id, :email, :full_name, :phone_country_code, :phone
    end
  end
end
