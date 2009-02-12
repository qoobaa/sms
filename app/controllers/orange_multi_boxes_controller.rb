class OrangeMultiBoxesController < ApplicationController
  def index
    @orange_multi_boxes = @current_user.orange_multi_boxes.paginate :page => params[:page], :order => "name ASC"
  end

  def show
    @orange_multi_box = @current_user.orange_multi_boxes.find(params[:id])
  end

  def new
    @orange_multi_box = @current_user.orange_multi_boxes.build
  end

  def create
    @orange_multi_box = @current_user.orange_multi_boxes.build(params[:orange_multi_box])
    if @orange_multi_box.save
      flash[:success] = "Orange Multi Box was successfully updated"
      redirect_to orange_multi_boxes_path
    else
      render :action => "new"
    end
  end

  def edit
    @orange_multi_box = @current_user.orange_multi_boxes.find(params[:id])
  end

  def update
    @orange_multi_box = @current_user.orange_multi_boxes.find(params[:id])
    if @orange_multi_box.update_attributes(params[:orange_multi_box])
      flash[:success] = "Orange Multi Box was successfully updated"
      redirect_to orange_multi_box_path(@orange_multi_box)
    else
      render :action => "edit"
    end
  end

  def delete
    @orange_multi_box = @current_user.orange_multi_boxes.find(params[:id])
  end

  def destroy
    @orange_multi_box = @current_user.orange_multi_boxes.find(params[:id])
    if @orange_multi_box.destroy
      flash[:success] = "Orange Multi Box was successfully destroyed"
    else
      flash[:error] = "This orange multi box has messages and can't be destroyed"
    end
    redirect_to orange_multi_boxes_path
  end
end
