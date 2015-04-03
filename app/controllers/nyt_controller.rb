require 'httparty'
require 'uri'
class NytController < ApplicationController

	# User manually inputs a topic of choice
	def user_choice
		# takes user's input from the form
		@user_search_term = URI.escape(params['topic'] + " " + params['location'])
		user_search_term = params['topic'] + " " +  params['location']
		# loads tweets with user input
		@tweets = load_tweets(@user_search_term)

		# removes duplicate tweets
		i = 0
		while i < @tweets.length do
			j = i + 1
			while j < @tweets.length do
				if @tweets[i].text == @tweets[j].text
					@tweets.delete_at(j)
				else
					j += 1
				end
			end
		i += 1
		end

		# removes retweets
		@tweets.each do |t|
			if t.text[0] == "R" && t.text[1] == "T"
				@tweets.delete(t)
			end
		end
		# gets guidestar orgs with user input
		@user_org = get_org(@user_search_term)

		# prevents guidestar from appending default results 
		if @user_org == nil || @user_org[0]["organization_name"] == "GuideStar USA, Inc."
			@user_org = [{"organization_name" => "No results found"}]
		else 
			@user_org = get_org(@user_search_term)
		end

		if @user_org == nil || @user_org[0]["organization_name"] == "GuideStar USA, Inc."
			@user_org = [{"organization_name" => "No results found"}]
		else 
			@user_org = get_org(@user_search_term)
		end

		if @user_org != nil
			@user_org_details = @user_org.map do |org|
				get_org_details(org["organization_id"])
			end
		end
		
		respond_to do |format|
			format.json { render json: [@tweets, @user_org, @user_search_term, user_search_term, @user_org_details] }
		end
	end

	# User picks NYT topic from top stories to display tweets and organizations
	def user_click
		@user_choice = params['topic']
		user_cgi_choice = URI.escape(params['topic'])

		# removes duplicate tweets
		@tweets = load_tweets(@user_choice)
		i = 0
		while i < @tweets.length do
			j = i + 1
			while j < @tweets.length do
				if @tweets[i].text == @tweets[j].text
					@tweets.delete_at(j)
				else
					j += 1
				end
			end
		i += 1
		end

		# removes retweets
		@tweets.each do |t|
			if t.text[0] == "R" && t.text[1] == "T"
				@tweets.delete(t)
			end
		end
		@user_choice_org = get_org(user_cgi_choice)

		# prevents guidestar from appending default results 
		if @user_choice_org[0]["organization_name"] == "GuideStar USA, Inc."
			@user_choice_org = [{"organization_name" => "No results found"}]
		else 
			@user_choice_org = get_org(user_cgi_choice)
		end

		if @user_choice_org == nil || @user_choice_org[0]["organization_name"] == "GuideStar USA, Inc."
			@user_choice_org = [{"organization_name" => "No results found"}]
		else 
			@user_choice_org = get_org(user_cgi_choice)
		end

		if @user_choice_org != nil
			@user_choice_org_details = @user_choice_org.map do |org|
				get_org_details(org["organization_id"])
			end
		end
		respond_to do |format|
			format.json { render json: [@tweets, @user_choice_org, @user_choice, @user_choice_org_details] }
		end

	end

	def get_article
		# gets top aritcles from the NYTimes API with HTTParty
		@articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")

		respond_to do |format|
			format.json { render json: @articles["results"] }
		end
	end

	# def topic
		# gets articles from the NYTimes API with HTTParty
		# @articles = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/all/world.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}")
	
		# Creates a hash of the results with the des_facet as the key 
		# and the articles as the value
		# des_hash = @articles['results'].group_by do |article|
		# 	article['des_facet'][0]
		# end
		
		# # Updates hash to have des_fact and geo_facet as key 
		# # and frequency of articles as the value
		# des_geo_hash = Hash.new { |h,k| h[k] = [] }
		# des_hash.each do |des_facet, article|
		# 	if des_facet && article[0]['geo_facet'][0]
		# 		if article[0]['geo_facet'][0].split.length > 1 
		# 			des_geo_hash[des_facet.split[0] + " " + article[0]['geo_facet'][0].split[0] + " " + article[0]['geo_facet'][0].split[1]] = article
		# 		else
		# 			des_geo_hash[des_facet.split[0] + " " + article[0]['geo_facet'][0].split[0]] = article
		# 		end
		# 	elsif des_facet && !article[0]['geo_facet'][0]
		# 		des_geo_hash[des_facet.split[0]] = article
		# 	elsif !des_facet && article[0]['geo_facet'][0]
		# 		if article[0]['geo_facet'][0].split.length > 1 
		# 			des_geo_hash[article[0]['geo_facet'][0].split[0] + " " + article[0]['geo_facet'][0].split[1]] = article
		# 		else
		# 			des_geo_hash[article[0]['geo_facet'][0].split[0]] = article
		# 		end
		# 	else
		# 		# do nothing
		# 	end
		# end
		# Changes the original hash to have the des_facet as they key
		# and the count of how many articles with that facet as the value
		# facet_count = Hash.new { |h,k| h[k] = [] }
		# des_geo_hash.each do |facet, articles|
		# 	facet_count[facet] = articles.length
		# end

		# removes all results that don't have a des_facet from the hash
		# facet_count.delete_if { |k,v| k == nil }
		# sorted_array = facet_count.sort_by{ |k,v| v}
		# top_story_array = sorted_array[-5..-1]
		
		# takes most frequently mentioned des_facet as the 1st search term
		# and uri escapes it to make it safe for URL search
		# first_term = top_story_array[4][0]
		# first_cgi = URI.escape(first_term)

		# takes 2nd most frequently mentioned des_facet as the 2nd search term
		# and uri escapes it to make it safe for URL search
		# second_term = top_story_array[3][0]
		# second_cgi = URI.escape(second_term)

		# takes 3rd most frequently mentioned des_facet as the 3rd search term
		# and uri escapes it to make it safe for URL search
		# third_term = top_story_array[2][0]
		# third_cgi = URI.escape(third_term)

		# sets nytimes results as search terms for twitter and guidestar
		# @search_term_1 = top_story_array[4][0]
		# @search_term_2 = top_story_array[3][0]
		# @search_term_3 = top_story_array[2][0]

		# gets tweets with top nytimes results
		# @tweets_1 = load_tweets(@search_term_1)
		# @tweets_2 = load_tweets(@search_term_2)
		# @tweets_3 = load_tweets(@search_term_3)

		# gets guidestar reults with top nytimes results
	# 	@first_org = get_org(first_cgi)

	# 	@second_org = get_org(second_cgi)

	# 	@third_org = get_org(third_cgi)

	# 	# prevents guidestar from appending default results when nil
	# 	if @first_org == nil || @first_org[0]["organization_name"] == "GuideStar USA, Inc."
	# 		@first_org = [{"organization_name" => "No results found"}]
	# 	else 
	# 		@first_org = get_org(first_cgi)
	# 	end

	# 	if @first_org != nil
	# 		@first_org_details = @first_org.map do |org|
	# 			get_org_details(org["organization_id"])
	# 		end
	# 	end

	# 	# prevents guidestar from appending default results when nil
	# 	if @second_org == nil || @second_org[0]["organization_name"] == "GuideStar USA, Inc."
	# 		@second_org = [{"organization_name" => "No results found"}]
	# 	else 
	# 		@second_org = get_org(second_cgi)
	# 	end

	# 	if @second_org != nil
	# 		@second_org_details = @second_org.map do |org|
	# 			get_org_details(org["organization_id"])
	# 		end
	# 	end

	# 	# prevents guidestar from appending default results when nil
	# 	if @third_org == nil || @third_org[0]["organization_name"] == "GuideStar USA, Inc."
	# 		@third_org = [{"organization_name" => "No results found"}]
	# 	else 
	# 		@third_org = get_org(third_cgi)
	# 	end
		
	# 	if @third_org != nil
	# 		@third_org_details = @third_org.map do |org|
	# 			get_org_details(org["organization_id"])
	# 		end		
	# 	end
		
	# 	respond_to do |format|
	# 		format.json { render json: [@tweets_1, @tweets_2, @tweets_3, @search_term_1, @search_term_2, @search_term_3, @first_org, @second_org, @third_org, @first_org_details, @second_org_details, @third_org_details] }
	# 	end
	# end

end