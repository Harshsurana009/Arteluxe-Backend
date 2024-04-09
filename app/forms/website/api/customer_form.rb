# frozen_string_literal: true

module Website
  module Api
    class CustomerForm < Rectify::Form
      attribute :full_name, String
      attribute :password, String
      attribute :phone, String
      attribute :phone_country_code, String, default: '+91'
      attribute :email, String

      validates :full_name, :phone_country_code,
                presence: true
      validates :password, presence: true, on: :create
      validates :email, presence: true
    end
  end
end
