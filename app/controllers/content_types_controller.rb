class ContentTypesController < ApplicationController
  before_action :set_content_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @content_types = ContentType.all
    respond_with(@content_types)
  end

  def show
    respond_with(@content_type)
  end

  def new
    @content_type = ContentType.new
    respond_with(@content_type)
  end

  def edit
  end

  def create
    @content_type = ContentType.new(content_type_params)
    @content_type.save
    respond_with(@content_type)
  end

  def update
    @content_type.update(content_type_params)
    respond_with(@content_type)
  end

  def destroy
    @content_type.destroy
    respond_with(@content_type)
  end

  private
    def set_content_type
      @content_type = ContentType.find(params[:id])
    end

    def content_type_params
      params.require(:content_type).permit(:name)
    end
end
