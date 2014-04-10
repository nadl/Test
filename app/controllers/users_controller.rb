
class UsersController < ApplicationController
  
  def cloud_create
    begin
      twitter_handle = params.has_key?(:twitter_handle) ? params[:twitter_handle] : ""
      @client = Twitter::Client.new
      @client.user(twitter_handle)
      @user = User.from_multunus(twitter_handle)
      @user_cloud_pattern = @user.history.nil? ?  Hash.new : eval(@user.history)
      @user.since_id = 1 if  @user.since_id.nil?
      @user.count = 0 if @user.count.nil?
      
      @tweets = @client.user_timeline(@user.twitter_handle, :count => 200, :since_id => @user.since_id.to_i)
      unless @tweets.blank?
         @tweets_count = @tweets.count
         @tweet_first_id = @tweets.first.id
         @tweet_last_id = @tweets.last.id
         @tweets.each do |tweet|
            words_count = tweet.text.split.size
            @user_cloud_pattern[words_count] = @user_cloud_pattern.has_key?(words_count) ? @user_cloud_pattern[words_count] + 1 : 1
         end
      
        @user.count +=  @tweets_count
        @user.save!
        begin
            @tweets = @client.user_timeline(@user.twitter_handle, :count => 200, :max_id => @tweet_last_id - 1, :since_id => @user.since_id.to_i )
            unless @tweets.blank?
              @tweets_count = @tweets.count
              @tweet_last_id = @tweets.last.id
              @tweets.each do |tweet|
                  words_count = tweet.text.split.size
                  @user_cloud_pattern.has_key?(words_count) ? (@user_cloud_pattern[words_count] = @user_cloud_pattern[words_count] + 1) : (@user_cloud_pattern[words_count] = 1)
              end
            @user.count +=  @tweets_count
            @user.save!
            else
              break
            end
        end while (@user.count.between?(200, 1000))
      @user.since_id = @tweet_first_id
      @user.history = Hash[@user_cloud_pattern.sort_by {|k,v| v}.reverse].to_s
      @user.save!
      end
      @flag = true if @user.history.nil?
    rescue Exception => exp
        if exp.to_s == "Sorry, that page does not exist"
          exp = "Sorry wrong Twitter Handle :P"
        end
       redirect_to '/' , :notice => exp
    end
    #render :text => "Wait Guru"
  end
end
