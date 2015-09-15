class ThemesController < ApplicationController

  # GET /themes
  # GET /themes.json
  def index
    @themes = Theme.all
  end


end
