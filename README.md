# ASKED : 

### posts controller

`$ rails g controller posts`

`$ rails g controller posts index new create show edit update destroy`



Show all posts : `index`

C :  `new` `create`

R : `show`

U : `edit` `update`

D : `destroy`



### post model

`rails g model post username:string title:string content:text`

`rake db:migrate` 

asked\db\schema.rb 에 적용됐는지 확인



### users controller

`$ rails g controller users index create`



### user model

`$ rails g model user username:string email:string password:string`

`$ rake db:migrate`





## HTTP Request (REST)

### get

### POST 요청

```ruby
# Error  ::: ActionController::InvalidAuthenticityToken

# /app/controllers/application_controller.rb 에 
# protect_from_forgery with: :exception
# 코드로 인해 발생! 사이트 보안, 인증을 위한 것이므로 지우면 안된다.

# ==> 해결방법
# new.html.erb 
# form 태그 안에 hidden 으로 authenticity_token을 전달해줘야 합니다.
<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>"/>
```



### PUT 요청

```ruby
# html put form 
# 일반적으로 form method는 'get'과 'post'만 지원
# 'put' 'delete' 등을 쓰고 싶을 땐 
<input type="hidden" name="_method" value="put" />



```



### Bcrypt

```ruby
# models/user.rb
class User < ActiveRecord::Base
  has_secure_password
end

# db/migrate/2018...
# t.string :password_digest
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.timestamps null: false
    end
  end
end

# users_controller.rb
# password_confirmation: 으로 생성해
      @user = User.new(username: params[:username],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirm])


            
```



```ruby
User.create(username:"hi", password:"123", password_confirmation:"1234")
   (0.1ms)  begin transaction
   (0.3ms)  rollback transaction
=> #<User id: nil, username: "hi", email: nil, password_digest: "$2a$10$/ysGQOlYBALcv3Vw1qRWv./pQNRAtZqOJnzAZPgSkeg...", created_at: nil, updated_at: nil>
       


```







# 전역으로 사용하는 View / Controller

```ruby
# app/controllers/application_controller.rb
  helper_method :current_user

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end


```





### 1:N Relation 

```ruby
# user가 여러개의 post를 가지고 있는 1:N 모델
# post 에 user 정보를 저장하는 것이 mapping 하기 좋으다?

#  /migrate/2018....._posts.rb
t.integer :user_id

# post.rb
belongs_to :user

# user.rb
has_many :posts
```



