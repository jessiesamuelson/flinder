class GuidestarController < ApplicationController
<<<<<<< HEAD
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
=======
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
>>>>>>> 8be8e4eb8d0077a56d4c7a08c52922eeb2ade5ce
