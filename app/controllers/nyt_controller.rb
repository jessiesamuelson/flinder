class NytController < ApplicationController
	require 'HTTParty'


	def get_article
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=")
		# binding.pry
		# @articles["results"][0]['subsection']
		# @articles["results"][0]['title']
		respond_to do |format|
			binding.pry
			format.json { render json: @articles["results"][0]['title'] }
		end
	end

end