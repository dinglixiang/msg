# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170912050236) do

  create_table "msgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", default: 0, null: false, comment: "发送者ID"
    t.integer "friend_id", default: 0, null: false, comment: "接收者ID"
    t.integer "sender_id", default: 0, null: false, comment: "发送者ID"
    t.integer "reciever_id", default: 0, null: false, comment: "接受者ID"
    t.integer "status", limit: 1, default: 0, null: false, comment: "0 未读，1 已读，2 删除"
    t.text "content", null: false, comment: "消息内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sender_id", "status", "reciever_id"], name: "index_msgs_on_sender_id_and_status_and_reciever_id"
    t.index ["user_id", "status", "friend_id"], name: "index_msgs_on_user_id_and_status_and_friend_id"
  end

  create_table "user_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", default: 0, null: false, comment: "用户ID"
    t.integer "friend_id", default: 0, null: false, comment: "联系人ID"
    t.integer "status", limit: 1, default: 0, null: false, comment: "好友状态, 0 好友 1 已删除"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "status", "friend_id"], name: "index_user_relations_on_user_id_and_status_and_friend_id"
  end

end
