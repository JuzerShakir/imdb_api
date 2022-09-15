class CreateShowJob < ApplicationJob
    queue_as :default

    def perform(url, identifier)
        @url = trim_url(url)
        @identifier = identifier
        connect_n_fetch
        save_show if valid_content?
    end

    after_perform do
        relational_data = [get_genres, get_stars, get_producers, get_directors]
        @browser.close
        @show.method("set_relations").call(relational_data) if @show.persisted?
    end

    private
        def save_show
            @show = content_type == "TV" ? TvShow.new : Movie.new
            @show.update( set_show_values )
        end
end