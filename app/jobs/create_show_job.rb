class CreateShowJob < ApplicationJob
    queue_as :default
    include ConnectToImdb, ExtractMetadata

    def perform(url)
        @url = url
        @identifier = get_identifier
        connect_n_fetch
        set_show if content_type_supported? && ratings_exists? && Entertainment.find_by(identifier: @identifier).nil?
        @browser.close
    end

    private
        def set_show
            @show = content_type == "TV" ? TvShow.new : Movie.new
            @show.identifier = @identifier
            @show.title = get_title
            @show.ratings = get_ratings
            @show.runtime = get_runtime
            @show.release_date = get_release_date
            @show.revenue = get_revenue
            @show.budget = get_budget
            @show.tagline = get_tagline
            @show.story = get_story
            @show.popularity = get_popularity
            @show.url = @url
            set_relations(get_genres, get_stars, get_producers, get_directors) if @show.save
        end

        def set_relations(genres, stars, producers, directors)
            set_genres(genres)
            set_stars(stars)
            set_producers(producers)
            set_directors(directors)
        end

        def set_genres(genres)
            genres.each do |genre|
                instance = Genre.find_by(name: genre)
                instance.nil? ? @show.genres.create(name: genre) : @show.genres << instance
            end
        end

        def set_stars(stars)
            stars.each do |star|
                instance = Star.find_by(name: star)
                instance.nil? ? @show.stars.create(name: star) : @show.stars << instance
            end
        end

        def set_producers(producers)
            producers.each do |producer|
                instance = Producer.find_by(name: producer)
                instance.nil? ? @show.producers.create(name: producer) : @show.producers << instance
            end
        end

        def set_directors(directors)
            directors.each do |director|
                instance = Director.find_by(name: director)
                instance.nil? ? @show.directors.create(name: director) : @show.directors << instance
            end
        end
end