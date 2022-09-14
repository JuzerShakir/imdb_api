class CreateShowJob < ApplicationJob
    queue_as :default

    def perform(url, identifier)
        @url = url.match(/(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7})/i)[0]
        @identifier = identifier
        connect_n_fetch
        save_show if valid_content?
    end

    after_perform do
        # relational_attrbs = [get_genres, get_stars, get_producers, get_directors]
        set_relations(get_genres, get_stars, get_producers, get_directors) if @show.persisted?
        @browser.close
    end

    private
        def set_show_values
            keys = %i(identifier title ratings runtime release_date revenue budget tagline popularity url)
            values = [@identifier, get_title, get_ratings, get_runtime, get_release_date, get_revenue,
                get_budget, get_tagline, get_popularity, @url]

            keys.zip(values).to_h
        end

        def save_show
            @show = content_type == "TV" ? TvShow.new : Movie.new
            @show.update( set_show_values )
        end

        def set_relations(*arrays)
            models = %w(Genre Star Producer Director)
            arrays.each_with_index { | arr, i |
                model = models[i]
                relation = @show.instance_eval("#{model.downcase}s")
                arr.each { |e|
                    instance = model.constantize.find_by(name: e)
                    instance.nil? ? relation.create(name: e) : relation << instance
                }
            }
        end

        # def set_genres(genres)
        #     genres.each do |genre|
        #         instance = Genre.find_by(name: genre)
        #         instance.nil? ? @show.genres.create(name: genre) : @show.genres << instance
        #     end
        # end
end