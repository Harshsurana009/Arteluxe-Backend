class Cart < ApplicationRecord
  # Associations
  has_many :items, class_name: 'CartItem', dependent: :destroy
  belongs_to :customer

  # Methods
  def amount
    items.map(&:amount).sum
  end

  def quantity
    items.map(&:quantity).sum
  end
end
