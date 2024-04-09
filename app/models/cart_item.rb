class CartItem < ApplicationRecord
  # Associations
  belongs_to :cart
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  # Methods
  def amount
    quantity * product.price
  end
end