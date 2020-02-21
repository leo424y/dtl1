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
        when 'youtube'
            '⏯️ '
        end
    end

    def is_name x
        exclude_name = %w(高雄市 高普考 葉克膜)
        last_name = %w(郝 陽 陳 林 黃 張 李 王 吳 劉 蔡 楊 許 鄭 謝 洪 郭 邱 曾 廖 賴 徐 周 葉 蘇 莊 呂 江 何 蕭 羅 高 潘 簡 朱 鍾 游 彭 詹 胡 施 沈 余 盧 梁 趙 顏 柯 翁 魏 孫  范 方 宋 鄧 杜 傅 侯 曹 薛 丁 卓 阮 馬 董 温 唐 藍 石 蔣 古 紀 姚 連 馮 歐 程 湯 黄 田 康 姜 白 汪 鄒 尤 巫 鐘 黎 涂 龔 嚴 韓 袁 金 童 陸 夏 柳 凃 邵)
        if (x.length == 3 ) && (last_name.include? x[0]) && (exclude_name.exclude? x)
          "<span style='color:red;'>#{x}</span>".html_safe
        else
          x
        end
    end    
end
