include ConnectAndValidate, ExtractMetadata

if Entertainment.exists?
    models = %w(Entertainment Genre Star Producer Director)
    models.each { |model| model.constantize.destroy_all }
end

def set_show_values
    keys = %i(identifier title ratings runtime release_date revenue budget tagline popularity url)
    values = [@identifier, get_title, get_ratings, get_runtime, get_release_date, get_revenue,
                get_budget, get_tagline, get_popularity, @url]

    keys.zip(values).to_h
end

def set_relations(*arrays)
    @browser.close
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

N = 60

files = %w(movie_links.txt tv-series_links.txt)

files.each do | file |
    file_content = File.open("#{Dir.pwd}/lib/seed_data/#{file}")
    all_shows = file_content.readlines.map(&:chomp)
    limited_shows = all_shows.first(N)
    show_batches = limited_shows.in_groups_of(30, false)
    total_batches = show_batches.count

    show_batches.each_with_index do | show_batch, i |
        show_batch.each do | show |
            @url = show
            @identifier = @url.match(/(tt\d{7})/)[0]
            connect_n_fetch
            @show = content_type == "TV" ? TvShow.new : Movie.new
            @show.update( set_show_values )
            @show.save
            set_relations(get_genres, get_stars, get_producers, get_directors)
        end
        sleep(30) if show_batch.count == 30 && i == total_batches
    end
end