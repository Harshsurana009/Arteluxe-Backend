# frozen_string_literal: true

class Order < ApplicationRecord
  # Mixins
  include UniqueRef
  configure_unique_ref_options field_name: :code, length: 10, prefix: 'OD',
                               generator: UniqueRef::REF_GENERATOR_NUMERIC

  # Associations
  belongs_to :customer
  has_many :bookings

  validates :amount, presence: true

  # State Machine
  generic_state_machine initial: :payment_due do
    event :confirm do
      transition from: %i[payment_due], to: :confirmed
    end

    event :complete do
      transition from: [:confirmed], to: :completed
    end

    event :reject do
      transition from: %i[payment_due], to: :rejected
    end

    event :cancel do
      transition from: %i[payment_due confirmed], to: :cancelled
    end
  end
end
