import Vapor

final class User: Model {
    var id: Node?
    var name: String
    var exists: Bool = false

    enum Error: Swift.Error {
        case userNotFound
        case registerNotSupported
        case unsupportedCredentials
    }

    init(name: String) {
        self.name = name
    }

    init(node: Node, in context: Context) throws {
        self.id = nil
        self.name = try node.extract("name")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }

    static func prepare(_ database: Database) throws {
        //
    }

    static func revert(_ database: Database) throws {
        //
    }
}

import Auth

extension User: Auth.User {
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        let user: User?

        switch credentials {
        case let id as Identifier:
            user = try User.find(id.id)
        case let accessToken as AccessToken:
            user = try User.query().filter("access_token", accessToken.string).first()
        case let apiKey as APIKey:
            user = try User.query().filter("email", apiKey.id).filter("password", apiKey.secret).first()
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }

        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not found")
        }

        return u
    }


    static func register(credentials: Credentials) throws -> Auth.User {
        throw Abort.custom(status: .badRequest, message: "Register not supported.")
    }
}

import HTTP

extension Request {
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }

        return user
    }
}
