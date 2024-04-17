class Address < ApplicationRecord

  # Validations
  validates :city, :state, :country, :address, presence: true

  # Associations
  belongs_to :resource, polymorphic: true

  # Methods
  def complete_address
    "#{address}, #{city}, #{state}, #{country}, #{zip_code}"
  end
end
