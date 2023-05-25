class SiteController < ApplicationController
  def home
    redirect_to(lists_path) and return if session_user.lists.exists?
    redirect_to list_path(session_user.lists.create!(title: "untitled"))
  end
end
