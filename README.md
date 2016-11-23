# Auth Example

A basic example using authentication. Contains a basic `User` class stored in a Fluent memory driver that can be registered, logged in, and then access protected routes.

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.

## Setup

Build the example app:

    swift build

Run the app:

    ./.build/debug/App

## Using the example app:

Create a user:

    curl -i -X "POST" "http://localhost:8080/users" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "{\"name\":\"tyler\"}"

    response:

    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Wed, 23 Nov 2016 22:04:06 GMT
    Content-Length: 23

    {"id":1,"name":"tyler"}


"Login" as a user, by posting the user id:

    curl -i -X "POST" "http://localhost:8080/users/login" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "{\"id\":\"1\"}"

    response, note the Cookie is set for this request

    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Wed, 23 Nov 2016 22:04:44 GMT
    Set-Cookie: vapor-auth=o+Q+hs+MgI7LD6BEV5elPA==; Expires=Wed, 30 Nov 2016 22:04:44 GMT; Path=/; HttpOnly
    Content-Length: 24

Fetch secured resource be sure to update the cookie from response above:

    curl -i -X "GET" "http://localhost:8080/users/secure" \
     -H "Cookie: vapor-auth=o+Q+hs+MgI7LD6BEV5elPA==" \
     -H "Content-Type: application/json; charset=utf-8"

    authenticated response:
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Wed, 23 Nov 2016 22:09:38 GMT
    Content-Length: 23

    {"id":1,"name":"tyler"}
