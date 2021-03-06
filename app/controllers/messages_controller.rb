class MessagesController < ApplicationController
  def index
    @messages = @current_user.messages.paginate(:page => params[:page])
  end

  def index_with_state
    @state = action_name
    @messages = @current_user.messages.paginate_by_aasm_state(@state, :page => params[:page])
    render :action => "index"
  end

  alias pending index_with_state
  alias delivered index_with_state

  def show
    @message = @current_user.messages.find(params[:id])
  end

  def new
    @message = @current_user.messages.build
    @gateways = @current_user.gateways
  end

  def create
    @message = @current_user.messages.build(params[:message])
    @gateways = @current_user.gateways
    @message.gateway = @gateways.find_by_id(params[:message][:gateway_id])
    if @message.save
      flash[:success] = "Message was successfully saved"
      redirect_to messages_path
    else
      render :action => "new"
    end
  end

  def edit
    @message = @current_user.messages.pending.find(params[:id])
    @gateways = @current_user.gateways
  end

  def update
    @message = @current_user.messages.pending.find(params[:id])
    @gateways = @current_user.gateways
    @message.gateway = @gateways.find_by_id(params[:message][:gateway_id]) if params[:message]
    if @message.update_attributes(params[:message])
      flash[:success] = "Message was successfully updated"
      redirect_to messages_path
    else
      render :action => "edit"
    end
  end

  def delete
    @message = @current_user.messages.find(params[:id])
  end

  def destroy
    @message = @current_user.messages.find(params[:id])
    @message.destroy
    redirect_to :action => @state
  end
end
