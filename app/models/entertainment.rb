class Entertainment < ApplicationRecord
    # * Associations
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :stars
    has_and_belongs_to_many :producers
    has_and_belongs_to_many :directors

    # * validations
    validates_presence_of :identifier
    validates_uniqueness_of :identifier, message: "must be unique"

    # * business logics
    # RATINGS
    scope :highest_rated, -> (n=10) { order(ratings: :desc).limit(n)}
    scope :lowest_rated, -> (n=10) { order(ratings: :asc).limit(n)}

    # RELEASE DATE
    scope :presence_of_release_date, -> { where("release_date IS NOT NULL") }
    scope :oldest_release, -> (n=10) { presence_of_release_date.order(release_date: :asc).limit(n) }
    scope :newest_release, -> (n=10) { presence_of_release_date.order(release_date: :desc).limit(n) }

    scope :released_in_year, -> (year) { where('extract(YEAR from release_date) = ?', year).order(title: :asc) }
    scope :released_in_month, -> (month) { where('extract(MONTH from release_date) = ?', month).order(title: :asc) }
    scope :released_in_day, -> (day) { where('extract(DOW from release_date) = ?', day ).order(title: :asc) } # ? accepts args frm 0-6 (Sun-Sat)

    # RUNTIME
    scope :longest, -> (n=10) { order(runtime: :desc, title: :asc).limit(n) }
    scope :shortest, -> (n=10) { order(runtime: :asc, title: :asc).limit(n) }

    # POPULARITY
    scope :popularity_in_millions, ->  { where("popularity > 1000000").order(popularity: :desc) }
    scope :popularity_within, -> (start, finish) { where(popularity: start..finish) }

end
