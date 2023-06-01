class TodosController < ApplicationController
  before_action :find_todo, only: [:edit, :update, :destroy]
  before_action :find_todos, only: [:index]

  def index
  end

  def create
    @todo = session_user.todos.new(todo_params)

    if @todo.save
      respond_to do |format|
        format.turbo_stream do
          render(
            turbo_stream: [
              turbo_stream.append("todos", partial: "todos/todo", locals: { todo: @todo }),

              turbo_stream.replace("toggle_todos", partial: "todos/forms/toggle", locals: { todos: find_todos }),
              turbo_stream.replace(helpers.dom_id(Todo.new), partial: "todos/forms/new", locals: { todo: Todo.new }),
              turbo_stream.update("todos_left", todos_left)
            ]
          )
        end
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
        format.turbo_stream do
          render(
            turbo_stream: todo_streams(@todo).
                            tap { |streams|
                              if filtering?
                                streams << turbo_stream.replace(
                                                          "toggle_todos",
                                                          partial: "todos/forms/toggle",
                                                          locals: { todos: find_todos }
                                                        )
                              end
                            }
          )
        end
      end
    else
      @autofocus = false # todo - the form submits in a loop without this b/c of the onblur
      render :edit, status: :unprocessable_entity
    end
  end

  def update_many
    todos = session_user.todos.where(id: params[:ids])
    todos.update_all(todo_params.to_h)

    respond_to do |format|
      format.turbo_stream do
        render(
          turbo_stream: todo_streams(todos).
                          tap { |streams|
                            if filtering?
                              streams << turbo_stream.replace(
                                                        "toggle_todos",
                                                        partial: "todos/forms/toggle",
                                                        locals: { todos: find_todos }
                                                      )
                            end
                          }
        )
      end
    end
  end

  def destroy
    @todo.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: todo_streams(@todo) }
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

    def todo_streams(todos)
      [turbo_stream.update("todos_left", todos_left)].tap do |streams|
        Array(todos).each do |todo|
          streams.unshift(
            if todo_visible?(todo)
              turbo_stream.replace(helpers.dom_id(todo), partial: "todos/todo", locals: { todo: todo })
            else
              turbo_stream.remove(helpers.dom_id(todo))
            end
          )
        end
      end
    end

    def todo_visible?(todo)
      return false if  todo.destroyed?
      return false if  todo.completed? && filtering?(:incompleted)
      return false if !todo.completed? && filtering?(:completed)
      true
    end
end
