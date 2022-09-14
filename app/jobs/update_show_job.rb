class UpdateShowJob < ApplicationJob
    queue_as :default
    include ConnectAndValidate, ExtractMetadata

    def perform(identifier)
        @identifier = identifier
        @url = "https://www.imdb.com/title/#{@identifier}"
        @show = Entertainment.find_by(identifier: identifier)

        connect_n_fetch

        @show.update( set_show_values )
        @browser.close
    end

    private
    def set_show_values
        keys = %i(ratings popularity revenue budget)
        values = [get_ratings, get_popularity, get_revenue, get_budget]
        keys.zip(values).to_h
    end
end