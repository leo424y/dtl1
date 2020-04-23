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

s.every '30m' do
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

s.every '1d' do 
  begin
    Post.pablo_api_import
  rescue => error
    p error
  end  
end

s.every '1m' do 
  begin
    Page.run_api Time.now.strftime('%M').to_i
  rescue => error
    p error
  end  
end

s.at '00:00:03' do
  Page.run_daily_domain_summarize
end