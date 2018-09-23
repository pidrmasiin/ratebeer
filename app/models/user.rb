class User < ApplicationRecord
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /((?=.*\d)(?=.*[a-z])(?=.*[A-Z]))/ },
                       length: { minimum: 4 }

  has_secure_password
  has_many :ratings # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
end
