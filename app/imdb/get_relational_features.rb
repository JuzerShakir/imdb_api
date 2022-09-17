module GetRelationalFeatures
    include ConnectAndValidate

    # * 1 genres
    def get_genres
        attrb = set_attr("genres")
        html = extract_data(:div, attrb, :text)
        html.gsub("\n", ' ').split
    end
    # * 2 stars
    def get_stars
        attrb = set_attr("title-cast-item__actor")
        html = extract_data(:as, attrb)
        html.map(&:text).first(5)
    end
    # * 3 production companies
    def get_producers
        if @browser.span(text: "Production companies").present?
            attrb = set_attr("title-details-companies")
            html = extract_data(:li, attrb, :div, :ul)
            html.map(&:text)
        end
    end
    # * 4 director name
    def get_directors
        attrb = set_attr("title-pc-principal-credit")
        html = extract_data(:li, attrb, :html)
        html.scan(/([\S ]+)<\/a>/).flatten
    end
end