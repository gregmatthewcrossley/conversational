class RemarksController < ApplicationController
  before_action :set_remark, only: %i[show edit update destroy]

  # GET /remarks or /remarks.json
  def index
    @remarks = Remark.all
  end

  # GET /remarks/1 or /remarks/1.json
  def show
  end

  # GET /remarks/new
  def new
    @remark = Remark.new
  end

  # GET /remarks/1/edit
  def edit
  end

  # POST /remarks or /remarks.json
  def create
    @remark = Remark.new(remark_params)

    respond_to do |format|
      if @remark.save
        format.html { redirect_to remark_url(@remark), notice: "Remark was successfully created." }
        format.json { render :show, status: :created, location: @remark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @remark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /remarks/1 or /remarks/1.json
  def update
    respond_to do |format|
      if @remark.update(remark_params)
        format.html { redirect_to remark_url(@remark), notice: "Remark was successfully updated." }
        format.json { render :show, status: :ok, location: @remark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @remark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remarks/1 or /remarks/1.json
  def destroy
    @remark.destroy!

    respond_to do |format|
      format.html { redirect_to remarks_url, notice: "Remark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_remark
    @remark = Remark.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def remark_params
    params.fetch(:remark, {})
  end
end
