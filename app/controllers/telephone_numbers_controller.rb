class TelephoneNumbersController < ApplicationController
  before_filter :require_user

  def index
    @query = params[:q]
    if @query
      @telephone_numbers = @current_user.telephone_numbers.find_all_by_number_like(@query)
    else
      @telephone_numbers = @current_user.telephone_numbers.paginate :page => params[:page], :order => "subscriber_number ASC"
    end
    respond_to do |format|
      format.html { render :action => "index" }
      format.text { render :text => @telephone_numbers.map(&:number).join("\n") }
    end
  end

  def show
    @telephone_number = @current_user.telephone_numbers.find(params[:id])
  end

  def new
    @telephone_number = @current_user.telephone_numbers.new
  end

  def create
    @telephone_number = @current_user.telephone_numbers.new(params[:telephone_number])
    if @telephone_number.save
      flash[:success] = "Telephone number was successfully saved"
      redirect_to telephone_number_path(@telephone_number)
    else
      render :action => "new"
    end
  end

  def delete
    @telephone_number = @current_user.telephone_numbers.find(params[:id])
  end

  def destroy
    @telephone_number = @current_user.telephone_numbers.find(params[:id])
    if @telephone_number.can_be_destroyed?
      @telephone_number.destroy
      flash[:success] = "Telephone number was successfully destroyed"
    else
      flash[:error] = "This telephone number has associated messages and can't be destroyed"
    end
    redirect_to telephone_numbers_path
  end
end
