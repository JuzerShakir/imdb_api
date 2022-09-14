class UpdateShowJob < ApplicationJob
    queue_as :default
    include ConnectAndValidate, ExtractMetadata

    def perform(identifier)
        @identifier = identifier
        @url = "https://www.imdb.com/title/#{@identifier}"
        @show = Entertainment.find_by(identifier: identifier)

        connect_n_fetch

        get_attributes = %i(ratings popularity revenue budget)
        set_attributes = [get_ratings, get_popularity, get_revenue, get_budget]
        updated_attributes = get_attributes.zip(set_attributes).to_h

        @show.update( updated_attributes )

        @browser.close
    end
end