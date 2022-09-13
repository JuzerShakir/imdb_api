module Api
    class EntertainmentsController < ApplicationController
        def create
            @url = entertainment_params[:url]

            if valid_url?
                CreateShowJob.perform_later @url
                render json: "Valid URL", status: :accepted
            else
                render json: "Invalid URL", status: :unprocessable_entity
            end
        end

        private

            def entertainment_params
                params.require(:entertainment).permit(:url)
            end

            def valid_url?
                valid_url = /(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7})/i
                @url.match?(valid_url)
            end
    end
end