class ListItemsController < ApplicationController
  
  def new
    @title = "LifeHelpr - New List Item"
    @list = List.find(params[:id])
    unless @list.user == current_user || admin?
      render :action => "noperms"
      return
    end
    @item = @list.list_items.new
  end
  
  def view
    @item = ListItem.find(params[:id])
    @title = "LifeHelpr - #{@item.name}"
    unless @item.list.user == current_user || admin?
      render :action => "noperms"
      return
    end
  end
  
  def edit
    @title="LifeHelpr - Edit Item"
    @item = ListItem.find(params[:id])
    @list = @item.list
    unless @item.list.user == current_user || admin?
      render :action => "noperms"
      return
    end
  end
  
  def update
    @item = ListItem.find(params[:id])
    unless @item.list.user == current_user || admin?
      render :action => "noperms"
      return
    end
    if @item.update_attributes(params[:list_item])
      flash[:notice] = "Item Updated"
      redirect_to :controller=>:lists, :action=>:view, :id=>@item.list_id
      return
    else
      flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'new'
      return
    end
  end
  
  def create
    @title = "LifeHelpr - New List Item"
    @list = List.find(params[:parent][:id])
    unless @list.user == current_user || admin?
      render :action => "noperms"
      return
    end
    if request.post?
      @user = current_user
      @item = @list.list_items.new(params[:list_item])
      if @item.save
        flash[:notice] = "Item Added"
        redirect_to :controller=>:lists, :action=>:view, :id => @item.list_id
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
        return
      end
    else
      render :action => 'new'
    end  
  end
  
  def delete
    if request.post?
      @list = List.find(params[:list_id])
      @item = ListItem.find(params[:id])
      unless @list.user == current_user || admin?
        render :action => "noperms"
        return
      end
      if @item.destroy
        flash[:notice] = "Item Deleted"
        redirect_to :controller=>:lists,:action=>:view, :id=>@list.id
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
        return
      end
    else
      flash[:error] = "You shouldn't poke things you don't understand..."
      redirect_to :controller=>:lists, :action=>:view, :id=>params[:list_id]
    end
  end
  
  def mark_done
    @title = "LifeHelpr - Mark Done"
    @user = current_user
    @item = ListItem.find(params[:id])
    unless @item.list.user == current_user || admin?
      render :action => "noperms"
      return
    end
    if request.post?
      old_value = params[:task][:completed]
      if old_value == 'false'
        @item.status = true
      end
      if old_value == 'true'
        @item.status = false
        @item.archived = false
      end
      if @item.save
        flash[:notice] = "#{@item.name} is done! WooHoo!"
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      end
      redirect_to :controller=>:lists, :action=>'view', :id=>@item.list.id
      return
    else
      redirect_to :controller=>:lists, :action=>'view', :id=>@item.list.id
      return
    end
  end
  
  def sort
    @list = List.find(params[:list_id])
    unless @list.user == current_user || admin?
      render :action => "noperms"
      return
    end
    @list.list_items.all.each do | f |
      f.position = params["todo_list"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true
  end
  
end
