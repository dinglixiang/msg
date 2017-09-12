## 私信系统

> 说明：
>
> - 假设users表已存在
> - 暂无验签
> - RESTful也可以理解为RPC的一种实现方式，暂未实现
> - 非业务异常报错用于监控，如插入数据失败
> - 仅完成基本实现，进一步方案如下
>   - 消息未读数量，后续可以用缓存
>   - 对性能有要求时，可使用Redis
> - Sorry
>   - 时间较紧，未完成写测试，仅自测接口
>   - 数据库连接池存在问题
>   - 未进行压测

### 安装及运行
```ruby
git clone git@github.com:dinglixiang/msg.git

cd msg
bundle install
# 修改数据库配置, mysql
vim config/database.yml
# 创建数据库
rake db:create DB=true
# 创建相关表
rake db:migrate DB=true
# 启动hprose server
rails s
# 另起一个窗口，运行客户端，调用服务
ruby client.rb
```

#### [请求示例](https://github.com/dinglixiang/msg/blob/master/client.rb)

### 设计思路

背景：周一周二空闲时间，时间紧

1. 基于Rails，使用ActiveRecord，快速实现业务逻辑；选择Hprose RPC框架，JSON数据传输，Hprose一看即懂，快速上手；而grpc等还需了解protocol buffer等内容。
2. 私信存储和联系人关系都采用了数据冗余，以空间换取时间，即插入两条数据(仅收发人对换)，以便满足私信的相关查询。
3. 具体表结构可参考[Migration](https://github.com/dinglixiang/msg/tree/master/db/migrate)
4. 修改Rails的启动顺序，启动Hprose Server端；基于http，实现RPC client调用

参考：

- [hprose-ruby](https://github.com/hprose/hprose-ruby)

- [hprose](http://hprose.com/)

  ​

### 接口文档

##### 约定：

- 返回结果格式，eg:`{code: 0, message: 'success', data: {}}`；其中code为业务代码，message为业务代码对应的说明信息, data可能为空
- 分页信息格式，列表为list，分页使用pagination，包含当前页、总页数、总数等信息，eg:`{code: 0, message: 'success', data: {list: [], pagination: {...}}`

##### 1. 【联系人】获取联系人列表

说明：根据user_id获取其联系人列表

###### 参数：

| 参数       | 类型      | 说明     | 备注    |
| -------- | ------- | ------ | ----- |
| user_id  | Integer | 当前用户ID |       |
| page     | Integer | 当前页    | 默认第一页 |
| per_page | Integer | 分页大小   | 默认10  |

###### 返回结果：

```json
# 正常
{
  "code": 0,
  "message": "success",
  "data": {
      "list": [
        {
          "friend_id": 1,
          "unread_count": 1
        }
        ,...],
        "pagination": {
          "total_pages": 1,
          "total_count": 1,
          "page": 1
        }
  }
}
```



##### 2. 【联系人】添加新联系人

说明：添加联系人，如用户A将B添加为联系人

参数：

| 参数        | 类型      | 说明     | 备注   |
| --------- | ------- | ------ | ---- |
| user_id   | Integer | 当前用户ID |      |
| friend_id | Integer | 新联系人ID |      |

###### 返回结果：

```json
# 正常
{
  "code": 0,
  "message": "success",
  "data": {}
}

# 异常
{
  "code": 1,
  "message": "had been friend",
}
```



##### 3. 【联系人】删除联系人

说明：删除指定联系人

参数：

| 参数        | 类型      | 说明     | 备注   |
| --------- | ------- | ------ | ---- |
| user_id   | Integer | 当前用户ID |      |
| friend_id | Integer | 联系人ID  |      |

###### 返回结果：

```json
# 正常
{
  "code": 0,
  "message": "success",
  "data": {}
}

# 异常
{
  "code": 2,
  "message": "user info error",
}
```



##### 4. 【私信】发送私信

说明：向指定用户发送私信

参数：

| 参数        | 类型      | 说明     | 备注   |
| --------- | ------- | ------ | ---- |
| user_id   | Integer | 当前用户ID |      |
| friend_id | Integer | 联系人ID  |      |
| content   | String  | 消息内容   | 仅文字  |

###### 返回结果：

```json
# 正常
{
  "code": 0,
  "message": "success",
  "data": {}
}

# 异常
{
  "code": 1,
  "message": "not friend",
}
```



##### 5.【私信】 获取与指定用户的私信历史记录

说明：获取与指定用户的私信记录

参数：

| 参数        | 类型      | 说明     | 备注    |
| --------- | ------- | ------ | ----- |
| user_id   | Integer | 当前用户ID |       |
| friend_id | Integer | 新联系人ID |       |
| page      | Integer | 当前页    | 默认第一页 |
| per_page  | Integer | 分页大小   | 默认10  |

###### 返回结果：

```json
# 正常
{
  "code": 0,
  "message": "success",
  "data": {
      "list": [
        {
          "id": 1,
          "status": "readed",
          "content": "test",
          "created_at": 1505226446
        }
        ,...],
        "pagination": {
          "total_pages": 1,
          "total_count": 1,
          "page": 1
        }
  }
}
```



##### 6. 【私信】标记私信为已读

说明：根据用户信息，将当前时间之前的私信皆标记为已读

参数：

| 参数          | 类型      | 说明    | 备注   |
| ----------- | ------- | ----- | ---- |
| sender_id   | Integer | 发送者ID |      |
| reciever_id | Integer | 接受者ID |      |

###### 返回结果：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```



##### 7. 【私信】删除私信

说明：删除当前用户发送的某个消息记录

参数：

| 参数      | 类型      | 说明     | 备注   |
| ------- | ------- | ------ | ---- |
| user_id | Integer | 当前用户ID |      |
| msg_id  | Integer | 消息内容ID |      |

###### 返回结果：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

