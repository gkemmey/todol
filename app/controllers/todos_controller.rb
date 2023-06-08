class TodosController < ApplicationController
  before_action :find_todo, only: [:edit, :update, :destroy]
  before_action :find_todos, only: [:index]

  def index
  end

  def create
    @todo = session_user.todos.new(todo_params)

    if @todo.save
      respond_to do |format|
        format.turbo_stream {
          # Turbo::StreamsChannel.broadcast_render_to(session_user.id, template: "todos/create", locals: { "@todo": @todo, filters: {} })
        }
      end
    else
      find_todos and render :index, status: :unprocessable_entity
    end
  end

  def edit
    @autofocus = true
  end

  def update
    if @todo.update(todo_params)
      respond_to do |format|
        format.turbo_stream {}
      end
    else
      @autofocus = false # todo - the form submits in a loop without this b/c of the onblur
      render :edit, status: :unprocessable_entity
    end
  end

  def update_many
    @todos = session_user.todos.where(id: params[:ids])
    @todos.update_all(todo_params.to_h)

    respond_to do |format|
      format.turbo_stream {}
    end
  end

  def destroy
    @todo.destroy!

    respond_to do |format|
      format.turbo_stream {}
    end
  end

  private

    def filtering?(mode = nil)
      return !params[:completed].nil? if mode.nil?

      return params[:completed] == "true"  if mode == :completed
      return params[:completed] == "false" if mode == :incompleted

      false
    end
    helper_method :filtering?

    def filters
      request.query_parameters
    end
    helper_method :filters

    def find_todo
      @todo = session_user.todos.find(params[:id])
    end

    def find_todos
      @todos = session_user.todos.where(filtering? ? { completed: filtering?(:completed) } : nil)
    end

    def todos_left
      session_user.todos.where(completed: false).count
    end
    helper_method :todos_left

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end
