module Api
    class EntertainmentsController < ApplicationController
        def create
            @url = entertainment_params[:url]

            if invalid_url?
                render json: { error: "Invalid URL" }, status: :unprocessable_entity
            elsif show_exists?
                render json: { error: "show already exists!" }, status: :unprocessable_entity
            else
                CreateShowJob.perform_later(@url, @identifier)
                render json: "Valid URL", status: :accepted
            end
        end

        private

            def entertainment_params
                params.require(:entertainment).permit(:url)
            end

            def invalid_url?
                valid_url = /(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7})/i
                !@url.match?(valid_url)
            end

            def show_exists?
                @identifier = get_identifier
                Entertainment.find_by(identifier: @identifier).persisted?
            end

            # * 15 Unique IMDb Id
            def get_identifier
                @url.match(/(tt\d{7})/)[0]
            end
    end
end