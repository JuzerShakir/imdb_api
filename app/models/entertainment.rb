class Entertainment < ApplicationRecord
    # * Constants
    RELATIONAL_MODELS = %w(genres stars producers directors)

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
    scope :highest_rated, -> { order(ratings: :desc, popularity: :desc)}
    scope :lowest_rated, -> { order(ratings: :asc, popularity: :desc)}
    scope :ratings_between, -> from, to { where(ratings: from..to).order(ratings: :asc, popularity: :desc) }

    # RELEASE DATE
    scope :presence_of_release_date, -> { where("release_date IS NOT NULL") }

    scope :oldest_release, -> { presence_of_release_date.order(release_date: :asc) }
    scope :newest_release, -> { presence_of_release_date.order(release_date: :desc) }

    scope :released_in_year, -> year { where('extract(YEAR from release_date) = ?', year).order(release_date: :asc) }
    scope :released_in_years_between, -> from, to { where('extract(YEAR from release_date) BETWEEN ? AND ?', from, to).order(release_date: :asc) }

    scope :released_in_month, -> month { where('extract(MONTH from release_date) = ?', month).order(release_date: :asc) }
    scope :released_in_months_between, -> from, to { where('extract(MONTH from release_date) BETWEEN ? AND ?', from, to).order(release_date: :asc) }

    # ? accepts args frm 0-6 (Sun-Sat)
    scope :released_in_day, -> day { where('extract(DOW from release_date) = ?', day ) }
    scope :released_in_days_between, -> from, to { where('extract(DOW from release_date) BETWEEN ? AND ?', from, to) }

    # RUNTIME
    scope :longest_runtime, -> { order(runtime: :desc, title: :asc) }
    scope :shortest_runtime, -> { order(runtime: :asc, title: :asc) }
    scope :runtime_between, -> from, to { where(runtime: from..to).order(runtime: :asc) }

    # POPULARITY
    scope :popularity_in_millions, ->  { where("popularity >= 1000000").order(popularity: :desc) }
    scope :popularity_between, -> from, to { where(popularity: from..to).order(popularity: :desc) }

    # DIRECTORS
    scope :directed_by, -> name { joins(:directors).where('directors.name LIKE ?', name) }

    # GENRES
    scope :in_genre, -> name {  joins(:genres).where('genres.name LIKE ?', name) }

    # PRODUCERS
    scope :produced_by, -> name {  joins(:producers).where('producers.name LIKE ?', name) }

    # STARS
    scope :starring, -> name {  joins(:stars).where('stars.name LIKE ?', name) }

    # returns all the useful features from the self and relational models
    def useful_features
        self.attributes.except(*unuseful).merge(names_of_relational_models)
    end

    private
        # select useful features from entertainment model
        def unuseful
            unuseful_attributes = %w(created_at updated_at url identifier)
            if self.type == "TvShow"
                more_attributes = %w(budget revenue profit)
                unuseful_attributes.concat(more_attributes)
            end
            unuseful_attributes
        end

        # selects only name field for all the relational models
        def names_of_relational_models
            RELATIONAL_MODELS.each_with_object({}) do | model, hash |
                hash[model] = self.instance_eval(model).pluck(:name)
            end
        end
end
