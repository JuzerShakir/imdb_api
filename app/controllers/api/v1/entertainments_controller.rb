module Api
    module V1
        class EntertainmentsController < ApplicationController
            before_action :params_permit_url, only: :create
            before_action :params_permit_identifier, except: :create
            before_action :get_show, except: :create

            def create
                if invalid_url?
                    render json: { error: "Invalid URL" }, status: :unprocessable_entity
                elsif show_exists?
                    render json: { error: "show already exists!" }, status: :unprocessable_entity
                else
                    CreateShowJob.perform_later(params[:url])
                    render json: { success: "Valid URL" },  status: :accepted
                end
            end

            def show
                if show_exists?
                    render json: @show, status: :ok
                else
                    render_error_of_no_id_exists
                end
            end

            def update
                if show_exists?
                    UpdateShowJob.perform_later(@show)
                    render json: { success: "Features are updating" }, status: :ok
                else
                    render_error_of_no_id_exists
                end
            end

            def destroy
                if show_exists?
                    @show.destroy
                    head :no_content
                else
                    render_error_of_no_id_exists
                end
            end

            private
                def params_permit_url
                    params.require(:entertainment).permit(:url)
                end

                def params_permit_identifier
                    params.require(:entertainment).permit(:identifier)
                end

                def render_error_of_no_id_exists
                    error_message = { error: "No show exists with this ID" }
                    render json: error_message, status: :unprocessable_entity
                end

                def invalid_url?
                    valid_url = /(\Ahttps:\/\/www.imdb.com\/title\/tt\d{7,8})/i
                    !params[:url].match?(valid_url)
                end

                def get_show
                    @show = Entertainment.find_by(identifier:  params[:identifier] || params[:url].match(/(tt\d{7,8})/)[0] )
                end

            def show_exists?
                @show
            end
        end
    end
end