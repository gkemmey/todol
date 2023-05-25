class ListsController < ApplicationController
  def index
  end

  def show
    @list = session_user.lists.find(params[:id])
  end
end
