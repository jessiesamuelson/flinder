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
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
		
		hash = @articles['results'].group_by do |article|
			article['des_facet']
		end
		
		# facet_count = Hash.new { |h,k| h[k] = [] }
		# hash.each do |facet, articles|
		# 	facet_count[facet] = articles.length
		# end
		
		# facet_count.delete_if { |k,v| k == "" }

		binding.pry
	end

end