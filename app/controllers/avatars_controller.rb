class AvatarsController < ApplicationController
  before_action :set_avatar, only: [:show, :edit, :update, :destroy]

  # GET /avatars
  # GET /avatars.json
  def index
    @avatars = Avatar.all
  end

  # GET /avatars/1
  # GET /avatars/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_avatar
      @avatar = Avatar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def avatar_params
      params.require(:avatar).permit(:name, :gender, :theme_id)
    end
end
