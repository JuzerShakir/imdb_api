    module GetStaticFeatures
        # * 1 title
        def get_title
            attrb = set_attr("hero-title-block__title")
            extract_data(:h1, attrb, :text)
        end

        # * 2 Unique IMDb Id
        def get_identifier
            @url.match(/(tt\d{7})/)[0]
        end

        # * 3 runtime in minutes
        def get_runtime
            if @browser.span(text: "Runtime").present?
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

        # * 4 release_date
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

        # * 5 tagline
        def get_tagline
           attrb = set_attr("plot-xl")
           # @browser.window.maximize
           html = extract_data(:span, attrb, :html)
           html.scan(/>([\S ]+)</).flatten.first
        end
    end