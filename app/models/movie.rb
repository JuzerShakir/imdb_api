class Movie < Entertainment
    # * callbacks
    before_save :set_profit

    # * business logic
    # REVENUE
    scope :presence_of_revenue, -> { where("revenue IS NOT NULL") }
    scope :highest_revenue, -> { presence_of_revenue.order(revenue: :desc) }
    scope :lowest_revenue, -> n=10 { presence_of_revenue.order(revenue: :asc).limit(n) }

    # BUDGET
    scope :presence_of_budget, -> { where("budget IS NOT NULL") }
    scope :highest_budget, -> { presence_of_budget.order(budget: :desc) }
    scope :lowest_budget, -> { presence_of_budget.order(budget: :asc) }

    # PROFIT
    scope :presence_of_profit, -> { where("profit IS NOT NULL") }
    scope :highest_profit, -> { presence_of_profit.order(profit: :desc) }
    scope :lowest_profit, -> { presence_of_profit.order(profit: :asc) }

    # RELEASE DATE
    scope :weekend_release, -> { presence_of_release_date.where.not('extract(DOW from release_date) BETWEEN 1 AND 5') }

    # chaining
    scope :weekend_release_with_highest_rating, -> { weekend_release.highest_rated.order(ratings: :desc) }
    scope :weekend_release_with_highest_profit, -> { weekend_release.highest_profit.order(profit: :desc) }
    scope :released_on_fridays, -> { presence_of_release_date.released_in_day(5).order(release_date: :asc) }

    private
        def set_profit
            unless self.revenue.nil? || self.budget.nil?
                self.profit = self.revenue - self.budget
            end
        end
end
