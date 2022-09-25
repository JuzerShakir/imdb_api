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
    scope :ratings_between, -> (from, to) { where(ratings: from..to).order(ratings: :asc) }

    # RELEASE DATE
    scope :presence_of_release_date, -> { where("release_date IS NOT NULL") }

    scope :oldest_release, -> (n=10) { presence_of_release_date.order(release_date: :asc).limit(n) }
    scope :newest_release, -> (n=10) { presence_of_release_date.order(release_date: :desc).limit(n) }

    scope :released_in_year, -> (year) { where('extract(YEAR from release_date) = ?', year).order(release_date: :asc) }
    scope :released_in_years_between, -> (from, to) { where('extract(YEAR from release_date) BETWEEN ? AND ?', from, to).order(release_date: :asc) }

    scope :released_in_month, -> (month) { where('extract(MONTH from release_date) = ?', month).order(release_date: :asc) }
    scope :released_in_months_between, -> (from, to) { where('extract(MONTH from release_date) BETWEEN ? AND ?', from, to).order(release_date: :asc) }

    # ? accepts args frm 0-6 (Sun-Sat)
    scope :released_in_day, -> (day) { where('extract(DOW from release_date) = ?', day ).order(release_date: :asc) }
    scope :released_in_days_between, -> (from, to) { where('extract(DOW from release_date) BETWEEN ? AND ?', from, to).order(release_date: :asc) }

    # RUNTIME
    scope :longest_runtime, -> (n=10) { order(runtime: :desc, title: :asc).limit(n) }
    scope :shortest_runtime, -> (n=10) { order(runtime: :asc, title: :asc).limit(n) }
    scope :runtime_between, -> (from, to) { where(runtime: from..to).order(runtime: :asc) }

    # POPULARITY
    scope :popularity_in_millions, ->  { where("popularity >= 1000000").order(popularity: :desc) }
    scope :popularity_between, -> (from, to) { where(popularity: from..to).order(popularity: :desc) }

    # DIRECTORS
    scope :all_shows_by_director, -> (name) { joins(:directors).where('directors.name LIKE ?', name) }

    # GENRES
    scope :all_shows_in_genre, -> (name) {  joins(:genres).where('genres.name LIKE ?', name) }

    # PRODUCERS
    scope :all_shows_by_producer, -> (name) {  joins(:producers).where('producers.name LIKE ?', name) }

    # STARS
    scope :all_shows_by_star, -> (name) {  joins(:stars).where('stars.name LIKE ?', name) }
end
