class User < ActiveRecord::Base
  attr_accessible :history, :since_id, :twitter_handle

  def self.from_multunus(twitter_handle)
   where(:twitter_handle => twitter_handle).first_or_initialize.tap do |user|
    user.twitter_handle = twitter_handle
    user.save!
   end
  end
end
