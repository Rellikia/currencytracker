module Uuidable
  include ActiveSupport::Concern

  def self.included(base)
    base.primary_key = :uuid
    base.before_create :assign_uuid
  end

  private
  def assign_uuid
    if self.uuid.blank?
      prefix = self.class.name.split('::').last[0..2]
      self.uuid = "#{prefix}#{UUIDTools::UUID.timestamp_create.to_s}".upcase
    end
  end
end