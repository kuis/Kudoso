class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @notes = Note.all
    respond_with(@notes)
  end

  def show
    respond_with(@note)
  end

  def new
    @note = Note.new
    respond_with(@note)
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
    @note.save
    respond_with(@note)
  end

  def update
    @note.update(note_params)
    respond_with(@note)
  end

  def destroy
    @note.destroy
    respond_with(@note)
  end

  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:ticket_id, :note_type_id, :title, :body)
    end
end
