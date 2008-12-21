class ContactsController < ApplicationController
  def index
    @contacts = @current_user.contacts.paginate :page => params[:page], :order => "name ASC"
  end

  def show
    @contact = @current_user.contacts.find(params[:id])
  end

  def new
    @contact = @current_user.contacts.new
  end

  def create
    @contact = @current_user.contacts.new(params[:contact])
    if @contact.save
      flash[:success] = "Contact was successfully saved"
      redirect_to contacts_path
    else
      render :action => "new"
    end
  end

  def edit
    @contact = @current_user.contacts.find(params[:id])
  end

  def update
    @contact = @current_user.contacts.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:success] = "Contact was successfully updated"
      redirect_to contacts_path
    else
      render :action => "edit"
    end
  end

  def delete
    @contact = @current_user.contacts.find(params[:id])
  end

  def destroy
    @contact = @current_user.contacts.find(params[:id])
    @contact.destroy
    redirect_to contacts_path
  end
end
