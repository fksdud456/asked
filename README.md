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



### user model







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

