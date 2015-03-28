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
		sorted_array = facet_count.sort_by{ |k,v| v}
		@top_story_array = sorted_array[-5..-1]
		# @top_story_array.each do |story|
		# 	load_tweets(story[0])
		# end
		load_tweets_1(@top_story_array[4][0])
		load_tweets_2(@top_story_array[3][0])
		load_tweets_3(@top_story_array[2][0])
		respond_to do |format|
			format.json { render json: [@tweets_1, @tweets_2, @tweets_3] }
		end
	end

end