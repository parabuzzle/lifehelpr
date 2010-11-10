class TodosController < ApplicationController
  before_filter :require_user
  before_filter :subnav
  
  in_place_edit_for Todo, :name
  in_place_edit_for Todo, :notes


  def subnav
    @subnav = [{'New Todo'=>'new'}, {'My Todo List'=>'index'}, {'Archived Todos'=>'archive'}, {'Categories' => {'controller'=>'categories', 'action'=>'index'}}]
  end
  def index
    @title = "LifeHelpr - Todo List"
    @user = current_user
    @categories = @user.categories
    @uncat_undone_count = @user.todos.find(:all, :conditions => {:status => false, :archived=>false, :deleted => false, :category_id=>nil}).count
    @uncat_archive_count = @user.todos.find(:all, :conditions => { :archived=>true, :deleted => false, :category_id=>nil}).count
    if params[:category]
      if params[:category] == 'Uncategorized'
        @todos = @user.todos.find(:all, :conditions => {:archived=>false, :deleted => false, :category_id=>nil})
      else
        category = Category.find_by_user_id_and_name(current_user.id, params[:category])
        if category
          @todos = category.todos_unarchived
          #@todos_late = category.todos.due_now
        else
          @todos = []
          #@todos_late = []
        end
      end
    else
      @todos = @user.todos.all
      @todos_late = @user.todos.due_now
    end
  end
  
  def archive
    @title = "LifeHelpr - Todo List Archive"
    @user = current_user
    if request.post?
      @todo = Todo.find(params[:id])
      unless @todo.user == current_user || admin?
        render :action => "noperms"
        return
      end
      @todo.archived = true
      if @todo.save
        flash[:notice] = "Todo has been archived"
        redirect_to :action => :view, :id => @todo.id
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        redirect_to :action => :view, :id => @todo.id
        return
      end
    end
    @categories = @user.categories
    @uncat_undone_count = @user.todos.find(:all, :conditions => {:status => false, :archived=>false, :deleted => false, :category_id=>nil}).count
    @uncat_archive_count = @user.todos.find(:all, :conditions => { :archived=>true, :deleted => false, :category_id=>nil}).count
    if params[:category]
      if params[:category] == "Uncategorized"
        @todos = @user.todos.find(:all, :conditions => {:archived=>true, :deleted => false, :category_id=>nil})
      else
        category = Category.find_by_user_id_and_name(current_user.id, params[:category])
        if category
          @todos = category.todos_archived
        else
          @todos = []
        end
      end
    else
      @todos = @user.todos.archived
    end
  end
  
  def set_todo_notes
    @todo = Todo.find(params[:id])
    unless @todo.user == current_user || admin?
      render :action => "noperms"
      return
    end
    @todo.notes = params[:value]
    @todo.save
    render :inline => @todo.notes
  end
  
  def sort
    @user = current_user
    @user.todos.all.each do | f |
      f.position = params["todo_list"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true
  end
  
  #def sort
  #  params[:todos].each_with_index do |id, index|
  #    Todo.update_all(['position=?', index+1], ['id=?', id])
  #  end
  #  render :nothing => true
  #end
  
  def view
    @user = current_user
    @todo = Todo.find(params[:id])
    unless @todo.user == current_user || admin?
      render :action => "noperms"
      return
    end
    @title = "LifeHelpr - #{@todo.name}"
  end
  
  def new
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @todo = @user.todos.new
    @categories = []
    @user.categories.each do |cat|
      @categories << cat.name
    end
    if request.xhr?
      @xhr = true
      render :layout => false
    end
  end
  
  def create
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @todo = @user.todos.new(params[:todo])
    unless params[:category][:name].nil?
      category = @user.categories.find_by_name(params[:category][:name])
    else
      category = nil
    end
    unless params[:duedate].nil? || params[:duedate] == ''
      due =  Date.parse(params[:duedate])
      @todo.duedate = due
    else
      @todo.duedate = nil
    end
    if params[:todo][:name] == ''
      flash[:error] = "You must name the todo"
      render :action=>:new
      return
    end
    if category.nil?
      category = @user.categories.new(:name=>params[:category][:name])
      unless category.name == ''
        category.save
      end
    end
    unless category.nil?
      unless category.name == ''
        @todo.category_id = category.id
      end
    end
    if @todo.save
      flash[:notice] = "Todo Item Added"
      redirect_to :action => "index"
    else
      flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'new'
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
  
  def mark_done
    @title = "LifeHelpr - Mark Done"
    @user = current_user
    @todo = Todo.find(params[:id])
    unless @todo.user == current_user || admin?
      render :action => "noperms"
      return
    end
    if request.post?
      old_value = params[:task][:completed]
      if old_value == 'false'
        @todo.status = true
        @todo.complete_date = Time.now
      end
      if old_value == 'true'
        @todo.status = false
        @todo.archived = false
        @todo.complete_date = nil
      end
      if @todo.save
        flash[:notice] = "#{@todo.name} is done!"
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      end
      redirect_to :action=>'index'
    else
      redirect_to :action => 'view', :id=>@todo.id
    end
  end
  
  def edit
    @title = "LifeHelpr - Edit Item"
    @user = current_user
    @todo = Todo.find(params[:id])
    @categories = []
    @user.categories.each do |cat|
      @categories << cat.name
    end
    unless @todo.user == current_user || admin?
      render :action => "noperms"
      return
    end
  end
  
  def update
    @title = "LifeHelpr - Edit Item"
    @user = current_user
    @todo = Todo.find(params[:id])
    unless @todo.user == current_user || admin?
      render :action => "noperms"
      return
    end
    category = false
    unless params[:category][:name].nil?
      category = Category.find_by_user_id_and_name(@user.id, params[:category][:name])
    end
    if category != false
      if params[:category][:name] == ''
        @todo.category_id = nil
      elsif category != nil
        @todo.category_id = category.id
      end
    end
    if params[:todo][:name] == ''
      flash[:error] = "Name cannot be blank"
      render :action=>:edit
      return
    end
    unless params[:duedate].nil? || params[:duedate] == ''
      due =  Date.parse(params[:duedate])
      @todo.duedate = due
    else
      @todo.duedate = nil
    end
    if @todo.update_attributes(params[:todo])
      flash[:notice] = "Successfully updated Item"
      redirect_to :action => "view", :id=>@todo.id
    else
      flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'edit'
    end
  end
  
end
