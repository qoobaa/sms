class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :delete, :destroy]

  def show
    @user = @current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Thank you for signing up"
      redirect_to root_path
    else
      render :action => :new
    end
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path
    else
      render :action => :edit
    end
  end

  def delete
    @user = @current_user
  end

  def destroy
    @user = @current_user
    @user.destroy
    redirect_to root_path
  end
end
