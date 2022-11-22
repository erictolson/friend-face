//
//  ContentView.swift
//  FriendFace
//
//  Created by Eric Tolson on 11/21/22.
//

import SwiftUI


struct User: Identifiable, Codable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    static let example = User(id: UUID(), isActive: true, name: "Eric", age: 30, company: "Example", email: "example", address: "example", about: "example", registered: Date.now, tags: ["example"], friends: [])

}

struct Friend: Identifiable, Codable {
    var id: UUID
    var name: String
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationView {
            VStack {
                List(users) { user in
                    NavigationLink {
                        DetailView(user: user)
                    } label: {
                        HStack {
                            Text(user.wrappedName)
                                .font(.headline)
                            Spacer()
                            Circle()
                                .frame(width: 15)
                                .foregroundColor(user.isActive ? .green : .white)
                                
                        }
                    }
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("FriendFace")
        }
    }
    
    func updateCache(with downloadedUsers: [User]) {
        for user in downloadedUsers {
            let cachedUser = CachedUser(context: moc)

            cachedUser.id = user.id
            cachedUser.isActive = user.isActive
            cachedUser.name = user.name
            cachedUser.age = Int16(user.age)
            cachedUser.company = user.company
            cachedUser.email = user.email
            cachedUser.address = user.address
            cachedUser.about = user.about
            cachedUser.registered = user.registered
            cachedUser.tags = user.tags.joined(separator: ",")

            for friend in user.friends {
                let cachedFriend = CachedFriend(context: moc)
                cachedFriend.id = friend.id
                cachedFriend.name = friend.name
                cachedUser.addToFriends(cachedFriend)
            }
        }

        try? moc.save()
    }
    
    func loadData() async {
        if (!users.isEmpty) { return }

        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
            await MainActor.run {
                updateCache(with: users)
            }
        } catch {
            print("Invalid Data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
