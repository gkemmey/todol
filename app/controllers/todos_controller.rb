class TodosController < ApplicationController
  before_action :find_todo, only: [:edit, :update, :destroy]
  before_action :find_todos, only: [:index]

  def index
  end

  def create
    @todo = session_user.todos.new(todo_params)

    if @todo.save
      redirect_to todos_path(filters)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      respond_to do |format|
        unless filtering?
          format.turbo_stream do
            render(
              turbo_stream: [
                turbo_stream.replace(helpers.dom_id(@todo), partial: "todos/todo", locals: { todo: @todo }),
                turbo_stream.update("todos_left", todos_left)
              ]
            )
          end
        end

        format.html { redirect_to todos_path(filters) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_many
    session_user.todos.where(id: params[:ids]).update_all(todo_params.to_h)
    redirect_to todos_path(filters)
  end

  def destroy
    @todo.destroy!
    redirect_to todos_path(filters)
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

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end

    def todos_left
      session_user.todos.where(completed: false).count
    end
    helper_method :todos_left
end
