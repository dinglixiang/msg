class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :user_id,     null: false, default: 0, comment: '发送者ID'
      t.integer :friend_id,   null: false, default: 0, comment: '接收者ID'
      t.integer :sender_id,   null: false, default: 0, comment: '发送者ID'
      t.integer :reciever_id, null: false, default: 0, comment: '接受者ID'
      t.integer :status,      null: false, default: 0, comment: '0 未读，1 已读，2 删除'
      t.text    :message,     null: false, comment: '消息内容'

      t.timestamp
    end

    add_index :messages, [:user_id, :status]
  end
end
