class Message < ApplicationRecord
  belongs_to :conversation, touch: :last_message_at
  belongs_to :sender, class_name: "Persona"

  validates :body, presence: true, length: { maximum: 2000 }
end
