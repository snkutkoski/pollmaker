# Serializable Model intended to separate data access/integrity logic from application logic
class ServiceModel
  include ActiveModel::Serialization

  attr_reader :errors, :id

  def initialize(id, errors)
    @errors = errors
    @id = id
  end

  def valid?
    @errors.blank?
  end

  # Convert an ActiveRecord model to a Service object
  def self.from_record
    raise NotImplementedError.new
  end
end
