class CreateShowJob < ApplicationJob
    include SetFeatures

    queue_as :default

    def perform(url)
        instantiate_browser_with(url)
        set_show_values if content_is_valid?
        @browser.close
    end
end