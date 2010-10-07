class TodosController < ApplicationController
  before_filter :require_user
  in_place_edit_for :todo, :subject
  def index
    @title = "LifeHelpr - Todo List"
    @user = current_user
    @todos = @user.todos.undone
  end
  
  def sort
    @user = current_user
    @user.todos.all(:conditions=>"status == 0").each do | f |
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
    @title = "LifeHelpr - #{@todo.name}"
  end
  
  def new
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @todo = @user.todos.new
    if params[:facebox]
      render :layout => false
    end
  end
  
  def create
    @title = "LifeHelpr - New Todo"
    @user = current_user
    @todo = @user.todos.new(params[:todo])
    if @todo.save
      flash[:notice] = "Todo Item Added"
      redirect_to :action => "index"
    else
      render :action => 'new'
    end
  end
  
  def mark_done
    @title = "LifeHelpr - Mark Done"
    @user = current_user
    @todo = Todo.find(params[:id])
    if request.post?
      @todo.status = 1
      if @todo.save
        flash[:notice] = "#{@todo.name} is done!"
      else
        flash[:error] = "couldn't mark complete"
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
  end
  
  def update
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
