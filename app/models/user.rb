class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3 }

  validates :password, length: { minimum: 4 },
                       format: {
                         with: /[A-Z].*\d|\d.*[A-Z]/,
                         message: "must contain one capital letter and number"
                       }


  def favorite_beer
    return nil if ratings.empty?
  
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    return nil if ratings.empty?

    thestyle = ''
    theaverage = 0

    ratings.map{ |rating| rating.beer.style }.uniq.each do |style|
      scores = ratings.select{ |rating| rating.beer.style == style }.map{ |rating| rating.score }
      average = scores.reduce(:+) / scores.size.to_f
      if average >= theaverage
        theaverage = average
        thestyle = style
      end
    end
    return thestyle
  end

  def favorite_brewery
    return nil if ratings.empty?

    thebrewery = ''
    theaverage = 0

    ratings.map{ |rating| rating.beer.brewery }.uniq.each do |brewery|
      scores = ratings.select{ |rating| rating.beer.brewery == brewery }.map{ |rating| rating.score }
      average = scores.reduce(:+) / scores.size.to_f
      if average >= theaverage
        theaverage = average
        thebrewery = brewery
      end
    end
    return thebrewery.name
  end
end