class GatewaysController < ApplicationController
  def index
    @gateways = @current_user.gateways.paginate :page => params[:page], :order => "name ASC"
  end

  def show
    @gateway = @current_user.gateways.find(params[:id])
  end

  def new
    @type = params[:type]
    if @type and Gateway.types.include? @type
      @gateway = @type.constantize.new
      @gateway.user = @current_user
    else
      render :action => "select_type"
    end
  end

  def create
    @type = params[:type]
    if @type and Gateway.types.include? @type
      @gateway = @type.constantize.new(params[:gateway])
      @gateway.user = @current_user
      if @gateway.save
        flash[:success] = "Gateway was successfully created"
        redirect_to gateways_path
      else
        render :action => "new"
      end
    else
      redirect_to new_gateway_path
    end
  end

  def edit
    @gateway = @current_user.gateways.find(params[:id])
  end

  def update
    @gateway = @current_user.gateways.find(params[:id])
    if @gateway.update_attributes(params[:gateway])
      flash[:success] = "Gateway was successfully updated"
      redirect_to gateway_path(@gateway)
    else
      render :action => "edit"
    end
  end

  def delete
    @gateway = @current_user.gateways.find(params[:id])
  end

  def destroy
    @gateway = @current_user.gateways.find(params[:id])
    if @gateway.destroy
      flash[:success] = "Gateway was successfully destroyed"
    else
      flash[:error] = "This gateway has messages and can't be destroyed"
    end
    redirect_to gateways_path
  end
end
