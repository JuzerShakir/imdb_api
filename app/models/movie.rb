class Movie < Entertainment
    # * callbacks
    before_save :set_profit

    private
        def set_profit
            unless self.revenue.nil? || self.budget.nil?
                self.profit = self.revenue - self.budget
            end
        end
end
