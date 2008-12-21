class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Login successful"
      redirect_back_or_default user_path
    else
      render :action => "new"
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Logout successful"
    redirect_back_or_default new_user_session_path
  end
end
