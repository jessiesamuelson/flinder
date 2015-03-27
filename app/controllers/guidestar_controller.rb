class GuidestarController < ApplicationController
  require 'HTTParty'

  def get_org
      # auth = {:username => Rails.application.secrets.guidestar_userName, :password => Rails.application.secrets.guidestar_password }

      auth = {:username => '', :password => '' }

      @orgs = HTTParty.get('https://sandboxdata.guidestar.org/v1/detail/7831216.json', :basic_auth => auth )

      respond_to do |format|
          format.json { render json: @orgs }
      end
  end

end