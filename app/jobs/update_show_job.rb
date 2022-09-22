class UpdateShowJob < ApplicationJob
    include UpdateFeatures

    queue_as :default

    def perform(show)
        @show = show
        instantiate_browser_with(@show.url)
        update_show_values
        @browser.close
    end
end