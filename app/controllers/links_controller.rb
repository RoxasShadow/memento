class LinksController < ApplicationController
  include LocalizationHelper
  before_action :authenticate_user!, only: [ :new, :create, :edit, :index, :edit, :update, :destroy ]

  def new
    @link = current_user.links.new
  end

  def create
    @link = current_user.links.create link_params

    if @link.save
      set_flash_message :notice, 'create'
      redirect_to @link
    else
      render 'new'
    end
  end

  def show
    @link = Link.find params[:id] rescue nil

    if @link
      respond_to do |format|
        format.html
        format.json { render json: @link }
      end
    else
      redirect_to links_path
    end
  end

  def index
    @links = current_user.links.all
    
    respond_to do |format|
      format.html
      format.json { render json: @links }
    end
  end

  def edit
    @link = current_user.links.find params[:id] rescue redirect_to links_path
  end

  def update
    @link = current_user.links.find params[:id] rescue redirect_to links_path

    if @link.update link_params
      set_flash_message :notice, 'edit'
      redirect_to @link
    else
      render 'edit'
    end
  end

  def destroy
    @link = current_user.links.find params[:id] rescue redirect_to links_path
    @link.destroy
    
    set_flash_message :notice, 'destroy'
    redirect_to links_path
  end

  def swap_priority
    new_link = current_user.links.find params[:new_id] rescue nil
    old_link = current_user.links.find params[:old_id] rescue nil

    res = if new_link && old_link
      new_link_params = { priority: old_link.priority } 
      old_link_params = { priority: new_link.priority } 
      new_link.update(new_link_params) && old_link.update(old_link_params)
    else
      'Link not found'
    end

    respond_to do |format|
      format.json { render json: res }
    end
  end

  def feeds
    url = Base64.decode64 params[:url]
    render text: open(url).read, content_type: 'application/xml+rss'
  end

  private
  def link_params
    params.require(:link).permit(:title, :url, :feeds, :description)
  end
end