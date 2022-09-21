class Producer < ApplicationRecord
    include Entertainments::Relations::Validations
    include HabtmModels::Scopes

    scope :produced_more_than, -> (n) { select("producers.id, name, COUNT(name) AS appearences")
                                                .joins(:entertainments)
                                                .group("producers.id").having("COUNT(name) > ?", n)
                                                .order(appearences: :desc, name: :asc)
    }
end
