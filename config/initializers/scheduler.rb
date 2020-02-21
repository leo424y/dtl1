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

s.every '1m' do
  begin
    Post.news_api_import
  rescue => error
    p error
  end
end

s.every '1d' do 
  Post.pablo_api_import
end


