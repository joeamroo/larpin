class Notification < ApplicationRecord
  belongs_to :persona
  belongs_to :actor, class_name: "Persona", optional: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(50) }
end
