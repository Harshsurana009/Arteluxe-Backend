# Mixin to generate and set unique ref field in any model
# supports 3 generators: numeric, alphanumeric and uuid, configure it after import
# ex.
# configure_unique_ref_options field_name: :transaction_ref, generator: :numeric, prefix: 'PWT', length: 15
module UniqueRef
  extend ActiveSupport::Concern
  include DbLowerFields

  REF_GENERATOR_NUMERIC = :numeric
  REF_GENERATOR_ALPHANUMERIC = :alphanumeric
  REF_GENERATOR_UUID = :uuid
  SUPPORTED_REF_GENERATORS = [REF_GENERATOR_NUMERIC, REF_GENERATOR_ALPHANUMERIC, REF_GENERATOR_UUID].freeze

  included do
    class_attribute :unique_ref_options
    before_validation :set_unique_ref, on: :create
    validate :validate_unique_ref
    validate :validate_ref_not_changed

    def set_unique_ref
      return if persisted?

      self[unique_ref_options[:field_name]] ||= self.class.generate_unique_ref(self)
    end
  end

  class_methods do
    def configure_unique_ref_options(field_name:, prefix: '', generator: :alphanumeric, length: 8, transformer: nil)
      unless generator.in?(SUPPORTED_REF_GENERATORS)
        raise Thrillo::Common::Errors::Base, "generator must one of #{SUPPORTED_REF_GENERATORS.join(', ')}"
      end

      self.unique_ref_options = { field_name: field_name.to_sym, prefix: prefix, generator: generator,
                                  length: length, transformer: transformer }
      set_lower_fields field_name
    end

    def generate_unique_ref(model = nil)
      ref = unique_ref_options[:prefix] + case unique_ref_options[:generator]
                                          when REF_GENERATOR_UUID
                                            SecureRandom.uuid
                                          when REF_GENERATOR_NUMERIC
                                            SecureRandom.rand.to_s[2..unique_ref_options[:length] + 1]
                                          when REF_GENERATOR_ALPHANUMERIC
                                            SecureRandom.alphanumeric(unique_ref_options[:length])
                                          else
                                            raise Thrillo::Common::Errors::Base,
                                                  "Invalid unique ref generator #{unique_ref_options}"
                                          end

      ref = unique_ref_options[:transformer].call(ref, model) if unique_ref_options[:transformer]&.is_a?(Proc)
      existing_record = if unique_ref_options[:generator] == REF_GENERATOR_ALPHANUMERIC
                          where("lower(#{unique_ref_options[:field_name]}) = lower(?)", ref)
                        else
                          where("#{unique_ref_options[:field_name]} = ?", ref)
                        end
      if existing_record.exists?
        Sentry.capture_message("Unique ref collision for #{ref}", extra: unique_ref_options)
        generate_unique_ref
      else
        ref
      end
    end
  end

  def validate_unique_ref
    # Only presence validation is checked, not checking actual ref because we are only generating it
    field = self.class.unique_ref_options[:field_name]
    errors.add(field, "#{field} must be present") if self[field].blank?
  end

  def validate_ref_not_changed
    field = self.class.unique_ref_options[:field_name]
    errors.add(field, 'Change is not allowed') if persisted? && send("#{field}_changed?".to_sym)
  end
end
