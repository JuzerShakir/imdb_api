module SetFeatures
    def set_attribute_values
        @all_show_attributes = %i(title identifier ratings runtime release_date revenue budget tagline popularity)

        @all_show_values = [get_title, get_identifier, get_ratings, get_runtime, get_release_date, get_revenue,
            get_budget, get_tagline, get_popularity]
    end

    def set_relational_values
        @relational_data = [get_genres, get_stars, get_producers, get_directors]
    end

    def set_show_values
        @show = content_type == "TV" ? TvShow.new : Movie.new
        @show.url = @url

        set_attribute_values
        @show.update( @all_show_attributes.zip(@all_show_values).to_h )

        set_relational_values if @show.persisted?
        @show.method("set_relations").call(@relational_data)
    end
end