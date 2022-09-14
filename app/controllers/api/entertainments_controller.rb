module Api
    class EntertainmentsController < ApplicationController
        def create
            @url = create_show_params[:url]

            if invalid_url?
                render json: { error: "Invalid URL" }, status: :unprocessable_entity
            elsif show_exists?(get_identifier)
                render json: { error: "show already exists!" }, status: :unprocessable_entity
            else
                CreateShowJob.perform_later(@url, @identifier)
                render json: "Valid URL", status: :accepted
            end
        end

        def update
            identifier = update_show_params[:identifier]

            if show_exists?(identifier)
                UpdateShowJob.perform_later(identifier)
                render json: "Features are updating.", status: :ok
            else
                error_message = { error: "Show doesn't exist with this id!" }
                render json: error_message, status: :unprocessable_entity
            end
        end

        private
            def update_show_params
                params.require(:entertainment).permit(:identifier)
            end

            def create_show_params
                params.require(:entertainment).permit(:url)
            end

            def invalid_url?
                valid_url = /(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7})/i
                !@url.match?(valid_url)
            end

            def show_exists?(identifier)
                @identifier = identifier
                Entertainment.exists?(identifier: @identifier)
            end

            # * 15 Unique IMDb Id
            def get_identifier
                @url.match(/(tt\d{7})/)[0]
            end
    end
end