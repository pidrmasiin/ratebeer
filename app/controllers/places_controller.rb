class PlacesController < ApplicationController
    def index
    end
  
    def search
      if(params[:city].empty?)
        return redirect_to places_path, notice: "No locations if city is empty"
      end
      @places = BeermappingApi.places_in(params[:city])
      if !params[:city].empty? && @places.empty?
        redirect_to places_path, notice: "No locations in #{params[:city]}"
      else
        render :index
      end  
    end
end