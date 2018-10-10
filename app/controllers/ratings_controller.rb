class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]

  def index
    @ratings = Rating.all
    @recent_ratings = Rating.recent
    @best_breweries = Brewery.top 3
    @best_beers = Beer.top 3
    @best_styles = Style.top 3
    @best_users = User.top 3
    render :index
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
    # talletetaan tehty reittaus sessioon
    # session[:last_rating] = "#{rating.beer.name} #{rating.score} points"
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
