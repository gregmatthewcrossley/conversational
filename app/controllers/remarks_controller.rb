class Controller < ApplicationController
  before_action :set_, only: %i[ show edit update destroy ]

  # GET / or /.json
  def index
    @ = .all
  end

  # GET //1 or //1.json
  def show
  end

  # GET //new
  def new
    @ = .new
  end

  # GET //1/edit
  def edit
  end

  # POST / or /.json
  def create
    @ = .new(_params)

    respond_to do |format|
      if @.save
        format.html { redirect_to _url(@), notice: " was successfully created." }
        format.json { render :show, status: :created, location: @ }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT //1 or //1.json
  def update
    respond_to do |format|
      if @.update(_params)
        format.html { redirect_to _url(@), notice: " was successfully updated." }
        format.json { render :show, status: :ok, location: @ }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE //1 or //1.json
  def destroy
    @.destroy!

    respond_to do |format|
      format.html { redirect_to _url, notice: " was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_
      @ = .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def _params
      params.require(:).permit(:title, :details, :location_id)
    end
end
