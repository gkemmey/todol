class Todo < ApplicationRecord
  after_create_commit  -> { broadcast_template_later(:create)  }
  after_update_commit  -> { broadcast_template_later(:update)  }
  after_destroy_commit -> { broadcast_template_later(:destroy) }

  before_validation { |t| t.title.try(:strip!) }
  validates :title, presence: true

  scope :created_by, -> (session_user) { where(session_user_id: session_user.try(:id) || session_user) }

  def self.todos_left(user)
    Todo.created_by(user).where(completed: false).count
  end

  private

    def broadcast_template_later(template)
      broadcast_render_later_to(
        session_user_id,
        template: "todos/#{template}",
        locals: { "@todo": self, todos_left: Todo.todos_left(session_user_id) }
      )
    end
end
