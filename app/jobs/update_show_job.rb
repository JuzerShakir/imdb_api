class UpdateShowJob < ApplicationJob
    queue_as :default

    def perform(identifier)
        @show = Entertainment.find_by(identifier: identifier)
        connect_n_fetch("https://www.imdb.com/title/#{identifier}")
        update_show_values
        @browser.close
    end
end