class AuditLine < ApplicationRecord
  # attribute :id, :uuid, default: -> { SecureRandom.uuid }
  # attribute :audit_id, :uuid

  # uuids [:id,:audit_id], auto: [:id]

  belongs_to :audit
end
