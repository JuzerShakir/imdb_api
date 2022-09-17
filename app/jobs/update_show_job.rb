class UpdateShowJob < ApplicationJob
    queue_as :default

    def perform(identifier)
        @show = Entertainment.find_by(identifier: identifier)
        instantiate_browser_with("https://www.imdb.com/title/#{identifier}")
        update_show_values
        @browser.close
    end
end