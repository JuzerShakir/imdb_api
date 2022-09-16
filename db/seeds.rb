include ConnectAndValidate, ExtractFeatures, ExtractRelationalFeatures, SetFeatures

if Entertainment.exists?
    models = %w(Entertainment Genre Star Producer Director)
    models.each { |model| model.constantize.destroy_all }
end

N = 1
G = 30

files = %w(movie_links.txt tv-series_links.txt)

files.each do | file |
    file_content = File.open("#{Dir.pwd}/lib/seed_data/#{file}")
    all_urls = file_content.readlines.map(&:chomp)
    limited_urls = all_urls.first(N)
    groups_of_urls = limited_urls.in_groups_of(G, false)
    number_of_groups = groups_of_urls.count

    groups_of_urls.each_with_index do | group_of_urls, i |
        group_of_urls.each do | url |
            connect_n_fetch(url)
            set_show_values
            @browser.close
        end
        sleep(30) if group_of_urls.count == G && i+1 != number_of_groups
    end
end