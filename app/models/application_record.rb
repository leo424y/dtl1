class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search_date(params)
    if params[:start_date].present? && params[:end_date].present? 
      start_date = params[:start_date].to_date.beginning_of_day
      end_date = params[:end_date].to_date.end_of_day
      where(:created_at => start_date..end_date)
    elsif params[:start_date].present?  
      start_date = params[:start_date].to_date.beginning_of_day
      where("created_at >= :start_date", start_date: start_date)
    elsif params[:end_date].present? 
      end_date = params[:end_date].to_date.end_of_day
      where("created_at <= :end_date", end_date: end_date)
    end
  end
  
end
