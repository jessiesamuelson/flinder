class NytController < ApplicationController
	require 'HTTParty'

	def get_article
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
		# @articles["results"][0]['subsection']
		# @articles["results"][0]['title']
		respond_to do |format|
			format.json { render json: @articles["results"] }
		end
	end

	# def topic
	# 	@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
	# 	first_facet = @articles['results'][3]['des_facet'][0]
		
	# 	array = []
	# 	@articles['results'].each do |article|
	# 		if article['des_facet'][0] == first_facet
	# 			array.push('bologne') 
	# 		end
	# 	end
	# 			binding.pry
	# end

	def topic
		# gets articles from the NYTimes API with HTTParty
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
	
		# Creates a hash of the results with the des_facet as the key 
		# and the articles as the value
		hash = @articles['results'].group_by do |article|
			article['des_facet'][0]
		end
		
		# Changes the original hash to have the des_facet as they key
		# and the count of how many articles with that facet as the value
		facet_count = Hash.new { |h,k| h[k] = [] }
		hash.each do |facet, articles|
			facet_count[facet] = articles.length
		end

		# removes all results that don't have a des_facet from the hash
		facet_count.delete_if { |k,v| k == nil }
	end

end