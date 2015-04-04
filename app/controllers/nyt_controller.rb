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

		# Removes tweets with the same first 4 words
		i = 0
		while i < @tweets.length do
			j = i + 1
			while j < @tweets.length do
				if @tweets[i].text.split.length > 4 && @tweets[j].text.split.length > 4
					if @tweets[i].text.split[0] == @tweets[j].text.split[0] &&
						@tweets[i].text.split[1] == @tweets[j].text.split[1] &&
						@tweets[i].text.split[2] == @tweets[j].text.split[2] &&
						@tweets[i].text.split[3] == @tweets[j].text.split[3] &&
						@tweets.delete_at(j)
					else
						j += 1
					end
				else
					if @tweets[i].text == @tweets[j].text
						@tweets.delete_at(j)
					else
						j += 1
					end
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
		if @user_org == nil || @user_org[0]["organization_id"] == 7831216
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

		@tweets = load_tweets(@user_choice)
		# Removes tweets with the same first 4 words
		i = 0
		while i < @tweets.length do
			j = i + 1
			while j < @tweets.length do
				if @tweets[i].text.split.length > 4 && @tweets[j].text.split.length > 4
					if @tweets[i].text.split[0] == @tweets[j].text.split[0] &&
						@tweets[i].text.split[1] == @tweets[j].text.split[1] &&
						@tweets[i].text.split[2] == @tweets[j].text.split[2] &&
						@tweets[i].text.split[3] == @tweets[j].text.split[3] &&
						@tweets.delete_at(j)
					else
						j += 1
					end
				else
					if @tweets[i].text == @tweets[j].text
						@tweets.delete_at(j)
					else
						j += 1
					end
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

end