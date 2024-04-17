# frozen_string_literal: true

class Payment < ApplicationRecord
  include UniqueRef
  configure_unique_ref_options field_name: :payment_ref, length: 16

  VALID_TYPES = %w[
    CustomerPayment
  ].freeze

  MANUAL_CAPTURE_TIME_IN_MINUTES = 60 * 24 * 1.5 # 1.5 days = 36 hrs
  AUTOCAPTURE_WINDOW_IN_MINUTES = 60 * 6 # 6 hours

  belongs_to :order
  has_many :bookings, through: :order

  validates :payment_ref, :amount, :state, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :type, inclusion: { in: VALID_TYPES }

  generic_state_machine initial: :created do
    event :initiate do
      transition from: :created, to: :initiated
    end

    event :authorized do
      transition from: :initiated, to: :authorized
    end

    event :succeed do
      transition from: %i[initiated authorized], to: :successful
    end

    event :failure do
      transition from: :initiated, to: :failed
    end

    after_transition to: :successful, do: :mark_order_as_paid
  end

  def enable_manual_capture?
    order.amount.to_f != amount.to_f
  end

  def pg_payment_collectable?
    authorized? || successful?
  end

  def is_last_payment_of_this_order?
    order.amount.to_f == amount.to_f
  end

  def mark_order_as_paid
    order.confirm! if order.can_confirm?
  end
end
