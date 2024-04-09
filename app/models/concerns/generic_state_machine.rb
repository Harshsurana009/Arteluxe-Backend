# frozen_string_literal: true

module GenericStateMachine
  extend ActiveSupport::Concern
  RESERVED_METHOD_NAMES = [:reject].freeze

  class_methods do
    def generic_state_machine(**args, &block)
      state_machine(**args, &block)

      state_machines[:state].states.map(&:name).each do |state|
        scope_name = state.in?(RESERVED_METHOD_NAMES) ? "with_#{state}" : state
        scope scope_name, -> { where(state: state) }
        scope "exclude_#{state}", -> { where.not(state: state) }
      end
    end

    def activable_state_machine(**args, &block)
      args.reverse_merge!({ initial: :inactive })

      generic_state_machine(**args) do
        event :activate do
          transition from: :inactive, to: :active
        end

        event :deactivate do
          transition from: :active, to: :inactive
        end

        event :mark_as_deleted do
          transition from: :inactive, to: :deleted
        end

        instance_eval(&block) if block_given?
      end
    end
  end
end
