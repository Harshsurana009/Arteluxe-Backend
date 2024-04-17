# frozen_string_literal: true

class Customer < ApplicationRecord
  # Constants
  EMAIL_REGEX = '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'

  # Plugins
  has_secure_password

  # Associations
  has_many :orders
  has_one :cart
  has_many :addresses, as: :resource

  # Validations
  validates :email, presence: true, uniqueness: true
  validates_presence_of :full_name, :phone, :phone_country_code
  validates :phone, phone: { possible: true,
                             allow_blank: true,
                             types: [:mobile],
                             country_specifier: lambda { |obj|
                                                  Phonelib.parse("#{obj.phone_country_code}#{obj.phone}").country.try(:upcase) || 'IN'
                                                } }

  # Callbacks
  after_create :create_cart

  private

  def create_cart
    Cart.create(customer: self)
  end
end
