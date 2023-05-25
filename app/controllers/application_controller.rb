class ApplicationController < ActionController::Base
  SessionUser = Data.define(:id) do
                  def todos
                    Todo.created_by(self)
                  end
                end

  private

    def session_user
      @session_user ||= SessionUser.new(id: session[:user_id] || generate_session_user_id)
    end

    def generate_session_user_id
      session[:user_id] = SecureRandom.hex
    end
end
