module SetFeatures
    include GetStaticFeatures, GetDynamicFeatures, GetRelationalFeatures

    def set_attribute_values
        @all_show_attributes = %i(title identifier ratings runtime release_date revenue budget tagline popularity)

        @all_show_values = [get_title, get_identifier, get_ratings, get_runtime, get_release_date, get_revenue,
            get_budget, get_tagline, get_popularity]
    end

    def set_relations
        with_models = %w(Genre Star Producer Director)
        relational_data = [get_genres, get_stars, get_producers, get_directors]

        relational_data.each_with_index { | relation, i |
            unless relation.nil?
                model = with_models[i]
                associated = @show.instance_eval("#{model.downcase}s")

                relation.each { |record|
                    instance = model.constantize.find_by(name: record)
                    instance.nil? ? associated.create(name: record) : associated << instance
                }
            end
        }
    end

    def set_show_values
        @show = content_type == "TV" ? TvShow.new : Movie.new
        @show.url = @url

        set_attribute_values
        @show.update( @all_show_attributes.zip(@all_show_values).to_h )

        set_relations if @show.persisted?
    end
end