class NytController < ApplicationController
	require 'HTTParty'
	require 'uri'

	def user_choice
		@user_search_term = URI.escape(params['topic'] + ' in ' + params['location'])
		@tweets_4 = load_tweets(@user_search_term)
		@user_org = get_org(@user_search_term)

		if @user_org[0]["organization_name"] == "GuideStar USA, Inc."
			@user_org = [{"organization_name" => "No results found"}]
		else 
			@user_org = get_org(@user_search_term)
		end
		
		respond_to do |format|
			format.json { render json: [@tweets_4, @user_org, @user_search_term] }
		end
	end

	def get_article
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")

		respond_to do |format|
			format.json { render json: @articles["results"] }
		end
	end

	def topic
		# gets articles from the NYTimes API with HTTParty
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
	
		# Creates a hash of the results with the des_facet as the key 
		# and the articles as the value
		des_hash = @articles['results'].group_by do |article|
			article['des_facet'][0]
		end

		des_geo_hash = Hash.new { |h,k| h[k] = [] }
		des_hash.each do |des_facet, article|
			if des_facet && article[0]['geo_facet'][0]
				if article[0]['geo_facet'][0].split.length > 1 
					des_geo_hash[des_facet.split[0] + " in " + article[0]['geo_facet'][0].split[0] + " " + article[0]['geo_facet'][0].split[1]] = article
				else
					des_geo_hash[des_facet.split[0] + " in " + article[0]['geo_facet'][0].split[0]] = article
				end
			elsif des_facet && !article[0]['geo_facet'][0]
				des_geo_hash[des_facet.split[0]] = article
			elsif !des_facet && article[0]['geo_facet'][0]
				if article[0]['geo_facet'][0].split.length > 1 
					des_geo_hash[article[0]['geo_facet'][0].split[0] + " " + article[0]['geo_facet'][0].split[1]] = article
				else
					des_geo_hash[article[0]['geo_facet'][0].split[0]] = article
				end
			else
				# do nothing
			end
		end

		# Changes the original hash to have the des_facet as they key
		# and the count of how many articles with that facet as the value
		facet_count = Hash.new { |h,k| h[k] = [] }
		des_geo_hash.each do |facet, articles|
			facet_count[facet] = articles.length
		end

		# removes all results that don't have a des_facet from the hash
		facet_count.delete_if { |k,v| k == nil }
		sorted_array = facet_count.sort_by{ |k,v| v}
		top_story_array = sorted_array[-5..-1]
		
		first_term = top_story_array[4][0]
		first_cgi = URI.escape(first_term)

		second_term = top_story_array[3][0]
		second_cgi = URI.escape(second_term)

		third_term = top_story_array[2][0]
		third_cgi = URI.escape(third_term)

		@search_term_1 = top_story_array[4][0]
		@search_term_2 = top_story_array[3][0]
		@search_term_3 = top_story_array[2][0]

		@tweets_1 = load_tweets(@search_term_1)
		@tweets_2 = load_tweets(@search_term_2)
		@tweets_3 = load_tweets(@search_term_3)

		@first_org = get_org(first_cgi)
		@second_org = get_org(second_cgi)
		@third_org = get_org(third_cgi)

		if @first_org[0]["organization_name"] == "GuideStar USA, Inc."
			@first_org = [{"organization_name" => "No results found"}]
		else 
			@first_org = get_org(first_cgi)
		end

		if @second_org[0]["organization_name"] == "GuideStar USA, Inc."
			@second_org = [{"organization_name" => "No results found"}]
		else 
			@second_org = get_org(second_cgi)
		end

		if @third_org[0]["organization_name"] == "GuideStar USA, Inc."
			@third_org = [{"organization_name" => "No results found"}]
		else 
			@third_org = get_org(third_cgi)
		end

		respond_to do |format|
			format.json { render json: [@tweets_1, @tweets_2, @tweets_3, @search_term_1, @search_term_2, @search_term_3, @first_org, @second_org, @third_org] }
		end
	end

end