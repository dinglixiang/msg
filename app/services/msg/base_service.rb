class Msg::BaseService < CommonService
  class << self
    def send_msg(user_id, friend_id, content)
      return failure(code: 1, message: 'not friend') unless UserRelation.exists?(user_id: user_id, friend_id: friend_id)
      attrs = {user_id: user_id, friend_id: friend_id, sender_id: user_id, reciever_id: friend_id, content: content}
      Msg.create!([attrs, attrs.merge(user_id: friend_id, friend_id: user_id)])
      success
    end

    def fetch_histories(user_id, friend_id, page = 1, per_page = 10)
      msgs = Msg.where(user_id: user_id, friend_id: friend_id, status: Msg.valid_statuses).order(id: :desc).page(page).per(per_page)
      success(list: msgs.map(&:info), pagination: pagination_info_of(msgs))
    end

    def mark_as_readed(sender_id, reciever_id)
      Msg.unread.where(sender_id: sender_id, reciever_id: reciever_id).where('created_at <= ?', Time.now).update_all(status: Msg.statuses[:readed], updated_at: Time.now)
      success
    end

    def destroy(user_id, msg_id)
      Msg.find_by(user_id: user_id, id: msg_id)&.removed!
      success
    end
  end
end
