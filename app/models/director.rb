class Director < ApplicationRecord
    include Entertainments::Relations::Validations
    include HabtmModels::Scopes

    scope :directed_more_than, -> n { select("directors.id, name, COUNT(name) AS appearences")
                                        .joins(:entertainments)
                                        .group("directors.id").having("COUNT(name) > ?", n)
                                        .order(appearences: :desc, name: :asc)
    }
end
