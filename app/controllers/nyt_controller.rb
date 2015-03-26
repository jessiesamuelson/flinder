class NytController < ApplicationController
	require 'HTTParty'

	def get_article
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
		# @articles["results"][0]['subsection']
		# @articles["results"][0]['title']
		respond_to do |format|
			format.json { render json: @articles["results"][0] }
		end
	end

end