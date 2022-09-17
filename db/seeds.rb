include ConnectAndValidate, GetStaticFeatures, GetDynamicFeatures, GetRelationalFeatures, SetFeatures

if Entertainment.exists?
    models = %w(Entertainment Genre Star Producer Director)
    models.each { |model| model.constantize.destroy_all }
end

N = 1                  # * Values acceptable between 1 to 250
URLS_IN_A_GROUP = 30      # ! Do NOT set value greater than 30 to avoid robot confiramtion

files = %w(movie_links.txt tv-series_links.txt)

files.each do | file |
    file_content = File.open("#{Dir.pwd}/lib/seed_data/#{file}")
    all_urls = file_content.readlines.map(&:chomp)
    limited_urls = all_urls.first(N)
    groups_of_urls = limited_urls.in_groups_of(URLS_IN_A_GROUP, false)
    number_of_groups = groups_of_urls.count

    groups_of_urls.each_with_index do | group_of_urls, i |
        group_of_urls.each do | url |
            instantiate_browser_with(url)
            set_show_values
            @browser.close
        end
        sleep(30) if group_of_urls.count == URLS_IN_A_GROUP && i+1 != number_of_groups
    end
end