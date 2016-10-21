class HomeController < ApplicationController
  class TwitterInfo
    def initialize
      @client = Twitter::REST::Client.new do |config|
        # ここにトークンを入れる
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SEACRET']
        config.access_token = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SEACRET']
      end
    end
    # 100件まで持ってくる
    def search_tweet(hashtag)
      retries = 0
      begin
        result_tweets = @client.search(hashtag, count: 10, filter: "images", include_entities: true, result_type: "recent")
        return result_tweets
      # ツイートを取得できなかった場合
      rescue Twitter::Error::ClientError
        render :text =>  "ツイートを取得できません"
      # APIのアクセス制限にかかった場合
      rescue Twitter::Error::TooManyRequests => error
        raise if retries >= 5
        retries += 1
        sleep error.rate_limit.reset_in
        render :text =>  "ツイートを取得できません"
        retry
      end
    end
  end

  def index
  # 戻り値が true ならサインイン済み。
    user_signed_in?
  # サインインしている全ユーザー取得
    current_user
  # ユーザーのセッション情報
    user_session
    @hash_tag = Array.new
    @user = Favorite.where(:user_name => current_user.email)
    @input = Favorite.new
  end

  def show
    if params[:favorite].present?
      @show = params[:favorite][:hash_tag]
    else
      redirect_to root_path
    end
    client = TwitterInfo.new()
    @result = client.search_tweet("##{@show}")
  end

  def new
    @input = Favorite.new
    if params[:favorite][:hash_tag] != ""
      @input[:hash_tag] = params[:favorite][:hash_tag]
      @input[:user_name] = current_user.email
      # すでに登録されているかどうか
      unless Favorite.exists?(hash_tag: @input[:hash_tag]) && Favorite.exists?(user_name: @input[:user_name])
        if @input.save
          redirect_to root_path
        else
          redirect_to root_path
        end
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

    def destroy
      @favo = Favorite.where(hash_tag:params[:hash_tag],user_name:current_user.email).first
      @favo.destroy
      redirect_to root_path
    end
end
