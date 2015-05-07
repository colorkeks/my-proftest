class ChaptersController < ApplicationController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /tests
  # GET /tests.json
  def index
    @chapters = Chapter.all
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
  end

  # GET /tests/new
  def new
    @chapter = Chapter.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to current_user, notice: 'Раздел успешно создан' }
      else
        format.html { redirect_to current_user, alert: 'Что-то пошло не так' }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to @chapter, notice: 'Chapter was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chapter_params
    params.require(:chapter).permit(:title)
  end
end