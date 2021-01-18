# README

#Authentication
#api/v1/signup *post*
```
{
	"user":{
		"email":"te2s2t@mail.com",
		"password":"123456",
		"phone_number": "+1 832 608 4658",
		"first_name":"Anibal",
		"last_name":"Rodriguez"
	}
}
```

#api/v1/verify *post*
```
{
	"pin":"0000",
	"phone_number": "+1 832 608 4658"
}
```

#api/v1/authenticate *post*
```
{
	"email": "te2s2t@mail.com",
	"password": "123456"
}
```

#api/v1/recover *post*
```
{
	"email":"te2s2t@mail.com"
}
```

#/api/v1/password_resets/#{code} *PUT*

```
{
	"user":{
		"password": "12345a"
	}
}
```

#http://localhost:3000/api/v1/generate *post*

```
{
	"email":"test@mail.com"
}
```

# POST api/v1/messages/:user_id
```
{
  "message": "example"
}
```

#api/v1 *get*

### any request should contains the header *Authorization*  follow of the token

#properties

A basic resources to `properties`

to upload multiples photos to a property pass "photo_data" : [ "...","..." ]
