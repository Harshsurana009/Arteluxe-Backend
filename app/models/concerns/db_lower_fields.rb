# frozen_string_literal: true

module DbLowerFields
  extend ActiveSupport::Concern

  class_methods do
    def set_lower_fields(*fields)
      return if fields.blank?

      fields.each do |field|
        next unless columns_hash[field.to_s].try(:type) == :string

        function_name = "find_by_#{field}".to_sym
        function_name_with_bang = "#{function_name}!".to_sym

        define_singleton_method function_name_with_bang do |value|
          find_by!("lower(#{field}) = lower(?)", value)
        end

        define_singleton_method function_name do |value|
          try(function_name_with_bang, value)
        rescue ActiveRecord::RecordNotFound => e
          nil
        end

        scope "with_#{field}", lambda { |value|
          if value.is_a? Array
            with_slugs(value)
          else
            where("lower(#{field}) = lower(?)", value)
          end
        }
        scope "with_#{field}s", lambda { |values|
          placeholders = values.map { |v| "'#{v}'" }.join(',')
          where("lower(#{field}) in (#{placeholders})", values)
        }
      end
    end
  end
end
