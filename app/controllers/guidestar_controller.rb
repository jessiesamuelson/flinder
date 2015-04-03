# require 'httparty'
class GuidestarController < ApplicationController

  # def get_org(search_term)
  #     auth = {:username => Rails.application.secrets.guidestar_username, :password => Rails.application.secrets.guidestar_password }


  #     @orgs = HTTParty.get("https://sandboxdata.guidestar.org/v1/search.json?q=#{search_term}&r=5", :basic_auth => auth )
  #     @orgs_list = @orgs["hits"]
  #     respond_to do |format|
  #         format.json { render json: @orgs_list }
  #     end
  # end

end