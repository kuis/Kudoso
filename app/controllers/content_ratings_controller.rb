class ContentRatingsController < ApplicationController
  before_action :set_content_rating, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @content_ratings = ContentRating.all
    respond_with(@content_ratings)
  end

  def show
    respond_with(@content_rating)
  end

  def new
    @content_rating = ContentRating.new
    respond_with(@content_rating)
  end

  def edit
  end

  def create
    @content_rating = ContentRating.new(content_rating_params)
    @content_rating.save
    respond_with(@content_rating)
  end

  def update
    @content_rating.update(content_rating_params)
    respond_with(@content_rating)
  end

  def destroy
    @content_rating.destroy
    respond_with(@content_rating)
  end

  private
    def set_content_rating
      @content_rating = ContentRating.find(params[:id])
    end

    def content_rating_params
      params.require(:content_rating).permit(:type, :tag, :short, :description)
    end
end
