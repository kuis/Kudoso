class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contents = Content.all
    respond_with(@contents)
  end

  def show
    respond_with(@content)
  end

  def new
    @content = Content.new
    respond_with(@content)
  end

  def edit
  end

  def create
    @content = Content.new(content_params)
    @content.save
    respond_with(@content)
  end

  def update
    @content.update(content_params)
    respond_with(@content)
  end

  def destroy
    @content.destroy
    respond_with(@content)
  end

  private
    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:content_type_id, :title, :year, :content_rating_id, :release_date, :language_id, :description, :length, :metadata, :references)
    end
end
