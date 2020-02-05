module ApplicationHelper
    def tw_time(x)
        # x.to_time ? (x.to_time + 8.hours).to_datetime : x
        x
    end

    def csv_url(x)
        r=x.split('?')
        model = r[0].split('/')[-1]
        "#{request.base_url}/#{model}.csv?#{r[1]}"
    end

    def title(text)
        content_for :title, text
    end

    def has_params
        params[:start_date] || params[:end_date]
    end   

    def media_icon x
        case x
        when 'facebook'
            '📘'
        when 'pablo'
            '🇨🇳'
        when 'news'
            '📰'
        end
    end
end
