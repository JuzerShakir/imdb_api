module Api
    class EntertainmentsController < ApplicationController
        before_action :permit_identifier, except: :create

        def create
            @url = params_permit_url[:url]

            if invalid_url?
                render json: { error: "Invalid URL" }, status: :unprocessable_entity
            elsif show_exists?
                render json: { error: "show already exists!" }, status: :unprocessable_entity
            else
                CreateShowJob.perform_later(@url)
                render json: "Valid URL", status: :accepted
            end
        end

        def show
            if show_exists?
                @show = Entertainment.find_by(identifier: @identifier)
                render json: @show, status: :ok
            else
                render_error_of_no_id_exists
            end
        end

        def update
            if show_exists?
                UpdateShowJob.perform_later(@identifier)
                render json: "Features are updating", status: :ok
            else
                render_error_of_no_id_exists
            end
        end

        def destroy
            if show_exists?
                Entertainment.find_by(identifier: @identifier).destroy
                head :no_content
            else
                render_error_of_no_id_exists
            end
        end

        private
            def render_error_of_no_id_exists
                error_message = { error: "No show exists with this ID" }
                render json: error_message, status: :unprocessable_entity
            end

            def params_permit_identifier
                params.require(:entertainment).permit(:identifier)
            end

            def permit_identifier
                @identifier = params_permit_identifier[:identifier]
            end

            def params_permit_url
                params.require(:entertainment).permit(:url)
            end

            def invalid_url?
                valid_url = /(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7,8})/i
                !@url.match?(valid_url)
            end

            def show_exists?
                Entertainment.exists?(identifier:  @identifier || @url.match(/(tt\d{7,8})/)[0] )
            end
    end
end