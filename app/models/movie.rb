class Movie < Entertainment
    # * callbacks
    before_save :set_profit

    private
        def set_profit
            self.profit = self.revenue - self.budget
        end
end
