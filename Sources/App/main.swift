import Vapor
import Auth
import Fluent

let database = Database(MemoryDriver())

let drop = Droplet(
    database: database
)

let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)
drop.preparations = [User.self]

drop.group("users") { users in
    users.post { req in
        guard let name = req.data["name"]?.string else {
            throw Abort.badRequest
        }

        var user = User(name: name)
        try user.save()
        return user
    }

    users.post("login") { req in
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }

        let creds = try Identifier(id: id)
        try req.auth.login(creds)
        
        return try JSON(node: ["message": "Logged in via default, check vapor-auth cookie."])
    }

    let protect = ProtectMiddleware(error:
        Abort.custom(status: .forbidden, message: "Not authorized.")
    )
    users.group(protect) { secure in
        secure.get("secure") { req in
            return try req.user()
        }
    }
}

drop.run()
