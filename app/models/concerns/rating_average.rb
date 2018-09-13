module RatingAverage
    extend ActiveSupport::Concern
   
    def average_rating()
        return ratings.average(:score)
    end
   end