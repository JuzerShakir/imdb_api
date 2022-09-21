class Star < ApplicationRecord
    include Entertainments::Relations::Validations
    include HabtmModels::Scopes

    scope :acted_in_more_than, -> (n) { select("stars.id, name, COUNT(name) AS appearences")
                                                .joins(:entertainments)
                                                .group("stars.id").having("COUNT(name) > ?", n)
                                                .order(appearences: :desc, name: :asc)
    }
end
