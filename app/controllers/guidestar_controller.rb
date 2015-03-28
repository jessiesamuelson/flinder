class GuidestarController < ApplicationController
  require 'HTTParty'

  def get_org
      # auth = {:username => Rails.application.secrets.guidestar_userName, :password => Rails.application.secrets.guidestar_password }

      auth = {:username => '', :password => '' }


      # @orgs = HTTParty.get('https://sandboxdata.guidestar.org/v1/search.json?q=environment&r=5', :basic_auth => auth )
      @orgs_list = @orgs["hits"]
      respond_to do |format|
          format.json { render json: @orgs_list }
      end
  end

end