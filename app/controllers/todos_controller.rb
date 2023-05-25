class TodosController < ApplicationController
  def index
    @todos = session_user.todos
  end

  def create
    @todo = session_user.todos.new(todo_params)

    if @todo.save
      redirect_to todos_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @todo = session_user.todos.find(params[:id])
  end

  def update
    @todo = session_user.todos.find(params[:id])

    if @todo.update(todo_params)
      redirect_to todos_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end
