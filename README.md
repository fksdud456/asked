# ASKED : rails new asked / rails s -b 0.0.0.0 



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



### [Rails 기본 라우팅](https://guides.rorlab.org/routing.html#%EB%A6%AC%EC%86%8C%EC%8A%A4-%EA%B8%B0%EB%B0%98%EC%9C%BC%EB%A1%9C-%EB%9D%BC%EC%9A%B0%ED%8C%85%ED%95%98%EA%B8%B0-rails%EC%9D%98-%EA%B8%B0%EB%B3%B8)

```ruby
# routes.rb
# index
get 'posts' => 'posts#index'

# CRUD -C
get 'posts/new' => 'posts#new'
post 'posts' => 'posts#create'	
# CRUD -R
get 'posts/:id' => 'posts#show'
# CRUD -U
get 'posts/:id/edit' => 'posts#edit'
put 'posts/:id' => 'posts#update'
# CRUD -D
destroy 'posts/:id' => 'posts#destroy'
```

```ruby
resources :posts
```

- REST API를 구성하는 기본원칙
  - URL은 정보의 자원을 표현한다.
  - 자원에 대한 행위는 HTTP method(verb)로 표현한다.



## HTTP Request (REST)

- ### get

- ### post

  - #### form에서 post요청 보내기

    Error  ::: ActionController::InvalidAuthenticityToken

    form post 요청에서 token이 없으면 오류가 발생한다.

    토큰을 사용하는 이유는 CSRF공격을 방지하기 위해서 ! 

    ```ruby
    # /app/controllers/application_controller.rb 에 
    # 코드로 인해 발생! 사이트 보안, 인증을 위한 것이므로 지우면 안된다. 
    protect_from_forgery with: :exception
    ```

    

    ```erb
    <!-- new.html.erb -->
    <!-- form 태그 안에 hidden 으로 authenticity_token을 전달해줘야 합니다. -->
    <form action="/posts" method="post">
        ..
    	<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>"/>
        ..
    </form>
    ```

- ### put

  ```ruby
  # html put form 
  # 일반적으로 form method는 'get'과 'post'만 지원
  # 'put' 'delete' 등을 쓰고 싶을 땐 
  <input type="hidden" name="_method" value="put" />
  ```

  

- ### delete

  ```erb
  <a href="/posts/<%=@post.id%>" data-method="delete" data-confirm="정말 삭제할래?"> 삭제하기 </a>
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





### [Database Relation(association)](https://guides.rorlab.org/association_basics.html) 

- ### 1:多

  User(1) - Post(N) 관계 설정

  유저는 많은 게시글을 가지고 있고, 게시글은 특정 유저에 속하기 때문

- 실제 코드 적용

  - 객체 관계 설정

    ```ruby
    # app/model/user.rb
    class User < ActiveRecord::Base
        has_many :posts
    end
    ```

    ```ruby
    # app/model/post.rb
    class Post < ActiveRecord::Base
        belongs_to :user
    end
    ```

  - 데이터베이스 관계 설정 

    `$ rake db:migrate`

    ```ruby
    # db/migrate/2018.._create_posts.rb
    ..
        t.string :title
        t.text :content
        t.integer :user_id	# Foreign key
    ..    
    ```

- 실제로 관계를 활용하기

  1. 유저가 가지고 있는 모든 게시글

     ```ruby
     # 1번 유저의 모든글
     @user_posts = User.find(1).posts
     
     # 글의 갯수
     count = User.find(1).posts.count
     ```

  2. 특정 게시글에서 작성한 사람 정보 출력

     ```ruby
     # 1번 글의 유저 작성자 이름
     @user_name = Post.find(1).user.username
     ```

     

### login

```ruby
# app/controllers/sessions_controller.rb

def new # get '/login'
end

def create # post '/login'
    # 로그인 성공시
    session[:user_id] = id
end

def destroy	# get '/logout'
    session.clear
end
```



### before filter : 컨트롤러

```ruby
# app/controllers/posts_controller.rb
# authorize method를 실행하는데, 여기 모든 액션 중에 index를 제외하고 실행
before_action :authorize, except: [:index]
```

```ruby
# app/contollers/application_controller.rb
def authorize
    unless current_user
        flash[:alert] = "로그인 해주세요"
        redirect_to '/'
    end
end
```



### helper method

```ruby
# View에서도 활용가능한 method로 만드는 법
# app/controllers/application_controller.rb

helper_method :current_user
def current_user
    @user ||= User.find(params[:id]) if session[:user_id]
    #user에 값이 없으면, 디비에 쿼리를 날리지 않는다.
end
```

- 뷰에서 활용

  ```erb
  <% if current_user %>
  	<p><%= current_user.username %></p>
  	<a href="/logout">로그아웃</a>
  <% else %>
  	<a href="/login">로그인</a>
  	<a href="/signup">회원가입</a>
  <% end %>
  ```