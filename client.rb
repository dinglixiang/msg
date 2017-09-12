require 'rubygems'
require 'hprose'

client = HproseClient.new('http://127.0.0.1:5000/')
def error(name, e)
  puts name
  puts e
end
client.onerror = :error

user = client.use_service(nil, :user)
msg = client.use_service(nil, :msg)

# 联系人列表
# @params: user_id
user.friends_of(1) { |result|
	puts '==联系人列表=='
	puts result
}.join

# 添加联系人
# @params: user_id, friend_id
user.add_friend_with(1, 2) { |result|
	puts '==添加联系人=='
	puts result
}.join

user.add_friend_with(1, 3) { |result|
	puts '==添加联系人=='
	puts result
}.join

# 删除联系人
# @params: user_id, friend_id
user.remove_friend_with(1, 3) { |result|
	puts '==删除联系人=='
	puts result
}.join

# 发送消息
# @params: user_id, friend_id, content
msg.send_msg(1, 4, 'test content') { |result|
	puts '==发送消息=='
	puts result
}.join

# 获取与指定联系人的私信记录
# @params: user_id, friend_id
msg.fetch_histories(2, 3) { |result|
	puts '==获取私信记录=='
	puts result
}.join

# 已读消息
# @params: sender_id, reciever_id
msg.mark_as_readed(1, 2) { |result|
	puts '==设置已读消息=='
	puts result
}.join

# 删除私信
# @params: user_id, msg_id
msg.destroy(1, 1) { |result|
	puts '==删除私信=='
	puts result
}.join
