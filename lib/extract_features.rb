    module ExtractFeatures
        # * 1 title
        def get_title
            attrb = set_attr("hero-title-block__title")
            extract_data(:h1, attrb, :text)
        end

        # * 2 Unique IMDb Id
        def get_identifier
            @url.match(/(tt\d{7})/)[0]
        end

        # * 3 rating
        def get_ratings
            attrb = set_attr("hero-rating-bar__aggregate-rating__score")
            html = extract_data(:div, attrb, :span, :html)
            html.scan(/\d[.]{1}\d/).pop.to_f
        end

        # * 4 runtime in minutes
        def get_runtime
            if @browser.span(text: "Runtime").present? &&
                attrb = set_attr("title-techspec_runtime")
                html = extract_data(:li, attrb, :text)
                hrs, mins = %w(hours minutes).map do | time |
                    t = html.scan(/(\d+) #{time}/).flatten.first
                    t.to_i unless t.nil?
                end

                hrs *= 60 unless hrs.nil?
                [hrs, mins].compact.reduce(:+)
            end
        end

        # * 5 release_date
        def get_release_date
            if @browser.link(text: "Release date").present?
                attrb = set_attr("title-details-releasedate")
                begin
                    Date.parse(extract_data(:li, attrb, :text, :lines, :last))
                rescue ArgumentError
                    nil
                end
            end
        end

        # * 6 revenue
        def get_revenue
            if @browser.span(text: "Gross worldwide").present?
                attrb = set_attr("title-boxoffice-cumulativeworldwidegross")
                extract_data(:li, attrb, :li, :text, :split, :first)
            end
        end

        # * 7 budget
        def get_budget
            if @browser.span(text: "Budget").present?
                attrb = set_attr("title-boxoffice-budget")
                extract_data(:li, attrb, :li, :text, :split, :first)
            end
        end

        # * 8 tagline
        def get_tagline
           attrb = set_attr("plot-xl")
           # @browser.window.maximize
           html = extract_data(:span, attrb, :html)
           html.scan(/>([\S ]+)</).flatten.first
        end

        # * 9 total users rated
        def get_popularity
            attrb = { css: ".sc-7ab21ed2-3.dPVcnq" }
            html = extract_data(:div, attrb, :html)
            html.scan(/>([0-9.M|K]+)/).flatten.first
        end
    end