class TodosController < ApplicationController
  before_action :find_todo, only: [:edit, :update, :destroy]

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
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_many
    session_user.todos.update_all(todo_params.to_h)
    redirect_to todos_path
  end

  def destroy
    @todo.destroy!
    redirect_to todos_path
  end

  private

    def find_todo
      @todo = session_user.todos.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end
