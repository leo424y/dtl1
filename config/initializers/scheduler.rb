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
  Post.ct_api_import
  Post.news_api_import
end
