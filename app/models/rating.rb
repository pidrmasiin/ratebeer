class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        return "#{beer.name}, score: #{score}"
    end
end
