class RecipientsController < ApplicationController
  def index
    @recipients = Recipient.find_by_user_and_name(@current_user, params[:q])
    respond_to do |format|
      format.text { render :text => @recipients.join("\n") }
    end
  end
end
