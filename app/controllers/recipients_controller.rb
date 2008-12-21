class RecipientsController < ApplicationController
  before_filter :require_user

  def index
    @query = params[:q]
    @telephone_numbers = @current_user.telephone_numbers.find_all_by_number_like(@query)
    @contacts = @current_user.contacts.find_all_by_name_like(@query)
    @recipients = []
    @recipients += @telephone_numbers.map(&:number)
    @recipients += @contacts.map(&:name)
    respond_to do |format|
      format.text { render :text => @recipients.join("\n") }
    end
  end
end
