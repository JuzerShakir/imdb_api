module SetFeatures
    def set_feature_values
        @features = %i(title identifier ratings runtime release_date revenue budget tagline popularity)

        @feature_values = [get_title, get_identifier, get_ratings, get_runtime, get_release_date, get_revenue,
            get_budget, get_tagline, get_popularity]
    end

    def set_relational_values
        @relational_features = [get_genres, get_stars, get_producers, get_directors]
    end

    def set_show_values
        @show = content_type == "TV" ? TvShow.new : Movie.new
        @show.url = @url

        set_feature_values
        @show.update( @features.zip(@feature_values).to_h )

        set_relational_values if @show.persisted?
        @show.method("set_relations").call(@relational_features)
    end
end