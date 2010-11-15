class CategoriesController < ApplicationController
  before_filter :require_user
  before_filter :subnav
  
  in_place_edit_for Category, :name

  def subnav
    @subnav = [{'New Todo'=>{'controller'=>'todos', 'action'=>'new'}}, {'My Todo List'=>{'controller'=>'todos', 'action'=>'index'}}, {'Archived Todos'=>{'controller'=>'todos', 'action'=>'archive'}}, {'Categories' => {'controller'=>'categories', 'action'=>'index'}}]
  end
  
  def index
    @title = "LifeHelpr - Todo Categories"
    @user = current_user
    @categories = @user.categories
    @uncat_undone_count = @user.todos.find(:all, :conditions => {:status => false, :archived=>false, :deleted => false, :category_id=>nil}).count
    @uncat_archive_count = @user.todos.find(:all, :conditions => { :archived=>true, :deleted => false, :category_id=>nil}).count
    @new = @user.categories.new
    @new.name = "Add New Category"
  end
  
  def new
    @title = "LifeHelpr - New Category"
    @user = current_user
    @category = @user.categories.new
    session[:return_to] = session[:previous]
  end
  
  def create
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @category = @user.categories.new(params[:category])
    if Category.find_by_name_and_user_id(params[:category][:name], @user.id)
      flash[:error] = "Category already exists"
      redirect_back_or_default(:action=>:index, :controller=>:users)
      return
    end
    if @category.save
      flash[:notice] = "Category added"
      redirect_back_or_default(:action=>:index, :controller=>:users)
      return
    else
      flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action=>:new
      return
    end
  end
  
  def delete
    if request.post?
      @todo = Todo.find(params[:id])
      unless @todo.user == current_user || admin?
        render :action => "noperms"
        return
      end
      @todo.deleted = true
      if @todo.save
        flash[:notice] = "Todo has been deleted"
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      end
      redirect_to :action => 'index'
    else
      redirect_to :action => 'view', :id => params[:id]
    end
  end
  
  def edit
  end
  def delete
    if request.post?
      @category = Category.find(params[:id])
      unless @category.user == current_user || admin?
        render :action => "noperms"
        return
      end
      @todos = @category.todos
      if @category.destroy
        @todos.each do |todo|
          todo.category_id = nil
          todo.save
        end
        flash[:notice] = "Todo has been deleted"
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      end
      redirect_to :action => 'index'
    else
      redirect_to :action => 'view', :id => params[:id]
    end
  end
end
