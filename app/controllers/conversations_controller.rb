class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[start end show edit update destroy]

  def converse
    # this is the root / default enpoint, which should find or create
    # a conversation based on the session ID
    @conversation = Conversation.find_or_create_by(session_id: session&.id.to_s)
    # render the show conversation view
    render "conversations/_conversation", locals: {conversation: @conversation}
  end

  def start
    respond_to do |format|
      format.json do
        @conversation.start!
        render json: {message: "Conversation started successfully."}
      end
    end
  end

  def end
    respond_to do |format|
      format.json do
        @conversation.end!
        render json: {message: "Conversation ended successfully."}
      end
    end
  end

  # GET /conversations or /conversations.json
  def index
    @conversations = Conversation.all
  end

  # GET /conversations/1 or /conversations/1.json
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations or /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to conversation_url(@conversation), notice: "Conversation was successfully created." }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1 or /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        start_or_end_conversation
        format.html { redirect_to conversation_url(@conversation), notice: "Conversation was successfully updated." }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1 or /conversations/1.json
  def destroy
    @conversation.destroy!

    respond_to do |format|
      format.html { redirect_to conversations_url, notice: "Conversation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def conversation_params
    params.require(:conversation).permit(
      :program_class,
      location_params: [
        :latitude,
        :longitude
      ]
    )
  end
end
