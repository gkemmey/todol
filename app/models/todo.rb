class Todo < ApplicationRecord
  belongs_to :list

  before_validation { |t| t.title.try(:strip!) }
  validates :title, presence: true

  scope :created_by, -> (session_user) { where(session_user_id: session_user.id) }
end
