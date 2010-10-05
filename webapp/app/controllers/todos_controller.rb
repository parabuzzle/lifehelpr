class TodosController < ApplicationController
  
  def index
    @title = "LifeHelpr - Todo List"
    require_user
    @user = current_user
    @todos = @user.todos
  end
  
  def view
    require_user
    @user = current_user
    @todo = Todo.find(params[:id])
    @title = "LifeHelpr - #{@todo.subject}"
  end
  
  def new
    @title = "LifeHelpr - New Todo"
    require_user
    @user = current_user
    @todo = @user.todos.new
  end
  
  def create
    require_user
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @todo = @user.todos.new(params[:todo])
    if @todo.save
      flash[:notice] = "Todo Item Added"
      redirect_to :action => "view", :id => @todo.id
    else
      render :action => 'new'
    end
  end
  
  def edit
    require_user
    @title = "LifeHelpr - Edit Item"
    @user = current_user
    @todo = Todo.find(params[:id])
  end
  
  def update
    require_user
    @title = "LifeHelpr - Edit Item"
    @user = current_user
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(params[:todo])
      flash[:notice] = "Successfully updated Item"
      redirect_to :action => "view", :id=>@todo.id
    else
      render :action => 'edit'
    end
  end
  
end
