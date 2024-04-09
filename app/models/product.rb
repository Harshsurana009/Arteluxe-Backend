# frozen_string_literal: true

class Product < ApplicationRecord
  # Mixins
  include MediaAttachable

  # Associations
  has_many :bookings
  has_many :orders, through: :bookings
  has_many :customers, through: :orders

  # Validations
  validates :name, :slug, :description, presence: true
  validates :price, :sticker_price, presence: true, numericality: { greater_than: 0 }

  # State Machine
  activable_state_machine(initial: :active)
end
