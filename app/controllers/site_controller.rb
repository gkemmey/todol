class SiteController < ApplicationController
  def home
    redirect_to lists_path
  end
end
