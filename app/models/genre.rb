class Genre < ApplicationRecord
    include Entertainments::Relations::Validations
    include HabtmModels::Scopes

    scope :appeared_more_than, -> n { select("genres.id, name, COUNT(name) AS appearences")
                                        .joins(:entertainments)
                                        .group("genres.id").having("COUNT(name) > ?", n)
                                        .order(appearences: :desc, name: :asc)
    }
end
