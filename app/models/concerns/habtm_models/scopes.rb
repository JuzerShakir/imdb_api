module HabtmModels
    module Scopes
        extend ActiveSupport::Concern
        included do
            scope :with_most_profit, -> n { select("name, SUM(profit) AS total_profits")
                .joins(:entertainments)
                .where("profit IS NOT NULL")
                .group("name")
                .order(total_profits: :desc, name: :asc)
                .limit(n)
            }
        end
    end
end