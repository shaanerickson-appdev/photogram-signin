class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def registration
    render({ :template => "users/registration"})
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    if !user.save
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence})
    else
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username })
    end
  end

  def logout
    reset_session
    redirect_to("/", { :notice => "See ya later!"})
  end

  def login
    render({ :template => "users/login"})
  end

  def authenticate
    password = params.fetch("input_password")
    username = params.fetch("input_username")
    user = User.where({ :username => username }).at(0)
    if !user
      redirect_to("/user_sign_in", { :alert => "Incorrect username or password" })
    elsif user.authenticate(password)
      session.store(:user_id, user.id)
      redirect_to("/", { :notice => "Welcome back, " + user.username})
    else
      redirect_to("/user_sign_in", { :alert => "Incorrect username or password"})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
