#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton

# Stupid recurrent task...
#
# s.every '10m' do
# end

s.every '1h' do
  begin
    Post.ct_api_import
  rescue => error
    p error
  end
end  

s.every '30m' do
  begin
    Post.news_api_import
  rescue => error
    p error
  end
end

# s.every '1d' do 
#   begin
#     Post.pablo_api_import
#   rescue => error
#     p error
#   end  
# end

s.every '3m' do 
  begin
    Page.run_api Time.now.strftime('%M').to_i
  rescue => error
    p error
  end  
end

s.cron '2 0 * * *' do
  begin
    Page.run_daily_domain_summarize
  rescue => error
    p error
  end  
end

s.cron '13 0 * * *' do
  begin
    Page.run_api_pablo
  rescue => error
    p error
  end  
end


s.cron '23 0 * * *' do
  begin
    Page.run_api_serp
  rescue => error
    p error
  end  
end
