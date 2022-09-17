module GetDynamicFeatures
    include ConnectAndValidate

    # * 1 rating
    def get_ratings
        attrb = set_attr("hero-rating-bar__aggregate-rating__score")
        html = extract_data(:div, attrb, :span, :html)
        html.scan(/\d[.]{1}\d/).pop.to_f
    end

    # * 2 revenue
    def get_revenue
        if @browser.span(text: "Gross worldwide").present?
            attrb = set_attr("title-boxoffice-cumulativeworldwidegross")
            str = extract_data(:li, attrb, :li, :text, :split, :first)
            str.scan(/\d+/).join.to_i

        end
    end

    # * 3 budget
    def get_budget
        if @browser.span(text: "Budget").present?
            attrb = set_attr("title-boxoffice-budget")
            str = extract_data(:li, attrb, :li, :text, :split, :first)
            str.scan(/\d+/).join.to_i
        end
    end

    # * 4 total users rated
    def get_popularity
        attrb = { css: ".sc-7ab21ed2-3.dPVcnq" }
        html = extract_data(:div, attrb, :html)
        html.scan(/>([0-9.M|K]+)/).flatten.first
    end
end