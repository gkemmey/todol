class List < ApplicationRecord
  include Permalinkable

  has_many :todos, dependent: :destroy

  before_validation { |t| t.title.try(:strip!) }
  validates :title, presence: true

  scope :created_by, -> (session_user) { where(session_user_id: session_user.id) }
end
