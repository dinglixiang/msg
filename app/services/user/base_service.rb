class User::BaseService < CommonService
  class << self
    def friends_of(user_id, page = 1, per_page = 10)
      friends = UserRelation.select(:friend_id).where(user_id: user_id).page(page).per(per_page)
      friend_ids = friends.map(&:friend_id)
      counts = Msg.unread.where(user_id: user_id, friend_id: friend_ids).group(:friend_id).count
      success(list: friend_ids.map{|id| {friend_id: id, unread_count: counts[id].to_i}}, pagination: pagination_info_of(friends))
    end

    def add_friend_with(user_id, friend_id)
      validate_the_users_on_create(user_id, friend_id)
      UserRelation.create!([{user_id: user_id, friend_id: friend_id}, {user_id: friend_id, friend_id: user_id}])
      success
    rescue HadBeenFriendError
      failure(code: 1, message: 'had been friend')
    end

    def remove_friend_with(user_id, friend_id)
      validate_the_users_on_destroy(user_id, friend_id)
      ActiveRecord::Base.transaction do
        UserRelation.find_by(user_id: user_id, friend_id: friend_id)&.removed!
        UserRelation.find_by(user_id: friend_id, friend_id: user_id)&.removed!
      end
      success
    rescue UserIDInvalidError
      failure(code: 2, message: 'user info error')
    end

    private

    def validate_the_users_on_create(user_id, friend_id)
      # TODO: 检验用户合法性
      raise HadBeenFriendError if exist_relation?(user_id, friend_id)
    end

    def validate_the_users_on_destroy(user_id, friend_id)
      raise UserIDInvalidError unless exist_relation?(user_id, friend_id)
    end

    def exist_relation?(user_id, friend_id)
      UserRelation.exists?(user_id: user_id, friend_id: friend_id)
    end
  end
end
