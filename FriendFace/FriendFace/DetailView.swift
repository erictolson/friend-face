//
//  DetailView.swift
//  FriendFace
//
//  Created by Eric Tolson on 11/21/22.
//

import SwiftUI

struct DetailView: View {
    let user: CachedUser
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUser>
    
    var body: some View {
        List {
            Section("About") {
                Text(user.wrappedAbout)
            }
            .headerProminence(.increased)
            
            Section("Friends") {
                ForEach(user.friendsArray) { friend in
                    NavigationLink {
                        DetailView(user: users.first(where: {$0.id == friend.id}) ?? user)
                    } label: {
                        Text(friend.wrappedName)
                    }
                }
            }
            .headerProminence(.increased)
        }
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(user: CachedUser())
    }
}
