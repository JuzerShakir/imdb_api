    module ConnectToImdb
        def connect_n_fetch
            @browser = Watir::Browser.new :chrome, headless: true
            @browser.goto @url
        end

        def extract_data(tag, attrb, *methods)
            html = @browser.send(tag, attrb)
            methods.inject(html) { |o, a| o.send(*a) }
        end

        # * create hash for HTML attribute and its value
        def set_attr(value, attribute = "data-testid")
            {"#{attribute}".to_sym => value }
        end

        # * returns true if rating exists
        def ratings_exists?
            attrb = set_attr("hero-rating-bar__aggregate-rating")
            extract_data(:div, attrb, :exists?)
        end

        # * know the content type of the imdb page : movie, tv-series, episode or game and only support movie and tvseries types
        def content_type
            attrb = set_attr("hero-title-block__metadata")
            extract_data(:ul, attrb, :text, :split, :first)
        end

        def content_type_supported?
            content_type.match?(/\A(\d+|TV)/)
        end
    end