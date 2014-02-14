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
    @links = current_user.links
    
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
    new_index = params[:new_id].to_i
    old_index = params[:old_id].to_i
    links     = current_user.links

    res = if links.length >= 2
      if ( (new_index + 1) - (old_index + 1) ).abs > 1
        if new_index > old_index
          links[old_index..new_index].each_with_index { |link, i|
            if i == old_index # item you're moving to the top
              link.update({ priority: link.priority + new_index })
            else
              link.update({ priority: link.priority - 1         })
            end
          }
        else # basso verso l'alto
          links[new_index..old_index].each_with_index { |link, i|
            if i == old_index # item you're moving to the top
              link.update({ priority: link.priority - old_index })
            else
              link.update({ priority: link.priority + 1         })
            end
          }
        end
      else # swap
        new_link = links[new_index]
        old_link = links[old_index]
        new_link.update({ priority: old_link.priority }) && old_link.update({ priority: new_link.priority })
      end
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