class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    if ratings_list.present?
      where(rating: ratings_list)
    else
      all
    end
  end
  def self.all_ratings
    ratings_hashmap = ['G', 'PG', 'PG-13', 'R'].each_with_object({}) do |item, hash|
      hash[item] = 1
  end
 end