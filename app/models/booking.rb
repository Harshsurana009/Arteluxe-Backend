# frozen_string_literal: true

class Booking < ApplicationRecord
  # Mixins
  include UniqueRef
  configure_unique_ref_options field_name: :code, prefix: 'BK', length: 10, transformer: proc { |ref| ref.upcase }

  # Associations
  belongs_to :customer
  belongs_to :product
  belongs_to :order

  # Validations
  validates :quantity, :unit_price, :amount, presence: true, numericality: { greater_than: 0 }
end
