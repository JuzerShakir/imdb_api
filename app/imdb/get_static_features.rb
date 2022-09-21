    module GetStaticFeatures
    include ConnectAndValidate

        # * 1 title
        def get_title
            attrb = set_attr("hero-title-block__title")
            extract_data(:h1, attrb, :text)
        end

        # * 2 Unique IMDb Id
        def get_identifier
            @url.match(/(tt\d{7,8})/)[0]
        end

        # * 3 release_date
        def get_release_date
            if @browser.link(text: "Release date").present?
                attrb = set_attr("title-details-releasedate")
                begin
                    Date.parse(extract_data(:li, attrb, :text, :lines, :last, :split).first(3).join)
                rescue ArgumentError
                    nil
                end
            end
        end

        # * 4 tagline
        def get_tagline
           attrb = set_attr("plot-xl")
           # @browser.window.maximize
           html = extract_data(:span, attrb, :html)
           html.scan(/>([\S ]+)</).flatten.first
        end
    end