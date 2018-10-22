class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    message = "Username and/or password mismatch"
    if user.closed
      message = "Your account is closed. Contact admin"
    end
    # seuraava &.-operaattoria käyttävä komento tarkottaa samaa kuin
    # user && user.authenticate(params[:password])
    if user&.authenticate(params[:password]) && !user.closed
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to signin_path, notice: message
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  # def gitbutton
  # end

  def create_oauth
    # puts "HALOOOOO"
    # puts request.env["omniauth.auth"]
    # puts H
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    # self.current_user = @user
    # redirect_to '/'
  end

  # protected

  # def auth_hash
  #   request.env['omniauth.auth']
  # end
end
