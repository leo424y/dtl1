class ApplicationController < ActionController::Base
    before_action :protect

    def protect
      @ips = ENV['IPOK'].split(',')
      unless request.remote_ip.start_with? *@ips
        render action: "unauth"
      end
    end
    
    def unauth
        render "pages/unauth"
    end
end
