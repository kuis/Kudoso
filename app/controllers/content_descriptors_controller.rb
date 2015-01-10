class ContentDescriptorsController < ApplicationController
  before_action :set_content_descriptor, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @content_descriptors = ContentDescriptor.all
    respond_with(@content_descriptors)
  end

  def show
    respond_with(@content_descriptor)
  end

  def new
    @content_descriptor = ContentDescriptor.new
    respond_with(@content_descriptor)
  end

  def edit
  end

  def create
    @content_descriptor = ContentDescriptor.new(content_descriptor_params)
    @content_descriptor.save
    respond_with(@content_descriptor)
  end

  def update
    @content_descriptor.update(content_descriptor_params)
    respond_with(@content_descriptor)
  end

  def destroy
    @content_descriptor.destroy
    respond_with(@content_descriptor)
  end

  private
    def set_content_descriptor
      @content_descriptor = ContentDescriptor.find(params[:id])
    end

    def content_descriptor_params
      params.require(:content_descriptor).permit(:tag, :short, :description)
    end
end
