class TodosController < ApplicationController
  before_action :find_list, only: :create

  def create
    @todo = @list.todos.new(todo_params).tap { |t| t.session_user_id = session_user.id }

    if @todo.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  private

    def find_list
      @list = List.find_by(permalink: params[:list_id]) || session_user.lists.find(params[:list_id])
    end

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end
