class BulkSerializer < ActiveModel::Serializer::CollectionSerializer
  def initialize(object:, serializer:, **args)
    super(object, serializer: serializer, **args)
  end
end
