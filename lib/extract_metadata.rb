    module ExtractMetadata
        # * 1 title
        def get_title
            attrb = set_attr("hero-title-block__title")
            extract_data(:h1, attrb, :text)
        end

        # * 2 rating
        def get_ratings
            attrb = set_attr("hero-rating-bar__aggregate-rating__score")
            html = extract_data(:div, attrb, :span, :html)
            html.scan(/\d[.]{1}\d/).pop.to_f
        end

        # * 4 director name
        def get_directors
            attrb = set_attr("title-pc-principal-credit")
            html = extract_data(:li, attrb, :html)
            html.scan(/([a-z .]+)<\/a>/i).flatten
        end

        # * 5 runtime in minutes
        def get_runtime
            if @browser.span(text: "Runtime").present? &&
                attrb = set_attr("title-techspec_runtime")
                html = extract_data(:li, attrb, :text)
                h, m = html.scan(/\d+/).map(&:to_i)
                [h, m].compact.length == 1 ? h : (h*60) + m
            end
        end

        # * 6 release_date
        def get_release_date
            if @browser.link(text: "Release date").present?
                attrb = set_attr("title-details-releasedate")
                Date.parse(extract_data(:li, attrb, :text, :lines, :last))
            end
        end

        # * 7 budget
        def get_budget
            if @browser.span(text: "Budget").present?
                attrb = set_attr("title-boxoffice-budget")
                extract_data(:li, attrb, :li, :text, :split, :first)
            end
        end

        # * 8 revenue
        def get_revenue
            if @browser.span(text: "Gross worldwide").present?
                attrb = set_attr("title-boxoffice-cumulativeworldwidegross")
                extract_data(:li, attrb, :li, :text, :split, :first)
            end
        end

        # * 9 genres
        def get_genres
            attrb = set_attr("genres")
            html = extract_data(:div, attrb, :text)
            html.gsub("\n", ' ').split
        end

        # * 10 tagline
        def get_tagline
           attrb = set_attr("plot-xl")
           # @browser.window.maximize
           html = extract_data(:span, attrb, :html)
           html.scan(/>([a-z0-9 ,.'ä:$-]+)/i).flatten.pop
        end

        # * 12 total users rated
        def get_popularity
            attrb = { css: ".sc-7ab21ed2-3.dPVcnq" }
            html = extract_data(:div, attrb, :html)
            html.scan(/>([0-9.M|K]+)/).flatten.pop
        end

        # * 13 stars
        def get_stars
            attrb = set_attr("title-cast-item__actor")
            html = extract_data(:as, attrb, :map)
            html.each(&:text)
        end

        # * 14 production companies
        def get_producers
            attrb = set_attr("title-details-companies")
            html = extract_data(:li, attrb, :div, :ul)
            html.map(&:text)
        end
    end