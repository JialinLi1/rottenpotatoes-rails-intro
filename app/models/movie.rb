class Movie < ActiveRecord::Base
  def self.get_all_ratings
    self.all.select(:rating).distinct.pluck(:rating)
  end
end
