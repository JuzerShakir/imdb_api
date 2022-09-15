class CreateShowJob < ApplicationJob
    queue_as :default

    def perform(url)
        connect_n_fetch(url)
        set_show_values if content_is_valid?
        @browser.close
    end
end