class ListsController < ApplicationController
  before_filter :require_user
  
  in_place_edit_for List, :name
  
  def index
    @title = "LifeHelpr - Your Lists"
    @user = current_user
    @lists = @user.lists.all
  end
  
  def new
    @title = "LifeHelpr - New List"
    @user = current_user
    @list = @user.lists.new
  end
  
  def create
    @title = "LifeHelpr - New List"
    @user = current_user
    if request.post?
      @list = @user.lists.new(params[:list])
      if @list.name == ''
        flash[:error] = "List must have a name"
        render :action=>:new
        return
      end
      if @list.save
        flash[:notice] = "List has been created"
        redirect_to :action=>:index
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
        return
      end
    else
      redirect_to :action=>:new
      return
    end
    render :action=>:new
  end
  
  def sort
    @user = current_user
    @user.lists.all.each do | f |
      f.position = params["todo_list"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true
  end
  
  def delete
    if request.post?
      @user = current_user
      @list = List.find(params[:id])
      unless @list.user == current_user || admin?
        render :action => "noperms"
        return
      end
      @list.list_items.each do |i|
        i.destroy
      end
      if @list.destroy
        flash[:notice] = "List has been deleted"
        redirect_to :action=>:index
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
        return
      end
    else
      flash[:error] = "What you are doing doesn't seem safe..."
      redirect_to :action=>:index
      return
    end
  end
end
