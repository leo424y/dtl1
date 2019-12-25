module ApplicationHelper
    def tw_time(x)
        (x.to_time + 8.hours).to_datetime
    end
end
