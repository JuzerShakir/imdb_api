module UpdateFeatures
    def set_update_values
        @dynamic_show_attributes = %i(ratings popularity revenue budget)
        @dynamic_show_values = [get_ratings, get_popularity, get_revenue, get_budget]
    end

    def update_show_values
        set_update_values
        @show.update(
            @dynamic_show_attributes.zip(@dynamic_show_values).to_h
        )
    end
end