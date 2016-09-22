import Vapor
import Auth
import Fluent

let auth = AuthMiddleware(user: User.self)

let database = Database(MemoryDriver())

let drop = Droplet(
    database: database,
    availableMiddleware: ["auth": auth],
    preparations: [User.self]
)

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

        return try JSON(node: ["message": "Logged in."])
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
