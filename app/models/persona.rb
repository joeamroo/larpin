class Persona < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :endorsements, dependent: :destroy
  has_many :given_endorsements, class_name: "Endorsement", foreign_key: :endorser_id, dependent: :destroy
  has_many :sent_connections, class_name: "Connection", foreign_key: :requester_id, dependent: :destroy
  has_many :received_connections, class_name: "Connection", foreign_key: :receiver_id, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :profile_skills, dependent: :destroy

  validates :name, presence: true, length: { maximum: 60 }
  validates :headline, presence: true, length: { maximum: 140 }
  validates :bio, length: { maximum: 1200 }

  scope :bots, -> { where(is_bot: true) }

  def connections_accepted
    Connection.accepted.involving(self)
  end

  def connection_count
    base_clout + connections_accepted.count
  end

  def clout_display
    n = connection_count
    n >= 500 ? "500+" : n.to_s
  end

  def connected_with?(other)
    Connection.accepted.between(self, other).exists?
  end

  def connection_with(other)
    Connection.between(self, other).first
  end

  def years_larping
    [((Date.current - larping_since) / 365.0).floor, 0].max
  end

  def initials
    name.split.map { |w| w[0] }.first(2).join.upcase
  end

  def unread_notifications_count
    notifications.where(read: false).count
  end

  def unread_messages_count
    Message.joins(:conversation)
      .where(read: false)
      .where.not(sender_id: id)
      .where("conversations.a_id = :id OR conversations.b_id = :id", id: id)
      .count
  end

  def top_skills
    endorsements.group(:skill).order(count_all: :desc).limit(6).count
  end
end
