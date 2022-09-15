include ConnectAndValidate, ExtractFeatures, ExtractRelationalFeatures, SetFeatures

if Entertainment.exists?
    models = %w(Entertainment Genre Star Producer Director)
    models.each { |model| model.constantize.destroy_all }
end

N = 1

files = %w(movie_links.txt tv-series_links.txt)

files.each do | file |
    file_content = File.open("#{Dir.pwd}/lib/seed_data/#{file}")
    all_shows = file_content.readlines.map(&:chomp)
    limited_shows = all_shows.first(N)
    show_batches = limited_shows.in_groups_of(30, false)
    total_batches = show_batches.count

    show_batches.each_with_index do | show_batch, i |
        show_batch.each do | show_url |
            connect_n_fetch(show_url)
            set_show_values
            @browser.close
        end
        sleep(30) if show_batch.count == 30 && i+1 != total_batches
    end
end