class BeersController < ApplicationController
  before_action :ensure_that_admin, only: [:destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  # GET /beers
  # GET /beers.json
  def index
    @order = params[:order] || 'name'
    # jos fragmentti olemassa, lopetetaan metodi tähän (eli renderöidään heti näkymä)
  return if request.format.html? && fragment_exist?("beerlist-#{@order}")

    @beers = Beer.includes(:brewery, :style).all

    @beers = case @order
            when 'name' then @beers.sort_by(&:name)
            when 'brewery' then @beers.sort_by{ |b| b.brewery.name }
            when 'style' then @beers.sort_by{ |b| b.style.name }
            end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    @breweries = Brewery.all
    @styles = Style.all
  end

  # GET /beers/1/edit
  def edit
    @beer = Beer.find(params[:id])
    @breweries = Brewery.all
    @styles = Style.all
  end

  # POST /beers
  # POST /beers.json
  def create
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    joku = Style.find(beer_params[:style])
    @beer = Beer.new(name: beer_params[:name], brewery_id: beer_params[:brewery_id], style: joku)
    puts @beer
    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        @styles = Style.all
        @breweries = Brewery.all
        format.html { render :new, notice: 'Name cant be empty' }
        format.json { render json: @beer.errors, notice: ':unprocessable_entity' }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    puts "haloooooo"
    puts beer_params
    copy = beer_params
    copy['style'] = Style.find(copy['style'])
    puts copy
    respond_to do |format|
      if @beer.update(copy)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, notice: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def average
    return 0 if ratings.empty?
    ratings.map(&:score).sum / ratings.count.to_f
  end

  def list
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beer_params
    params.require(:beer).permit(:name, :style, :brewery_id)
  end

  def set_styles
    b = Beer.all
    names = b.map(&:style)
    names.uniq
  end
end
