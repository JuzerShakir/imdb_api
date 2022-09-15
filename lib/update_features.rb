module UpdateFeatures
    def set_update_values
        @features = %i(ratings popularity revenue budget)
        @feature_values = [get_ratings, get_popularity, get_revenue, get_budget]
    end

    def update_show_values
        set_update_values
        @show.update( @features.zip(@feature_values ).to_h )
    end
end