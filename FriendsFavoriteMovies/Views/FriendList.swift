//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by Aiarsien on 21.03.2025.
//

import SwiftUI
import SwiftData

struct FriendList: View {
    @Query(sort: \Friend.name) private var friends: [Friend]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(friends) { friend in
                    NavigationLink(friend.name){
                        FriendDetail(friend: friend)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem {
                    Button("Add Friend", systemImage: "plus", action: addFriend)
                }
            }
        } detail: {
            Text("Select a friend")
                .navigationTitle("Friend")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addFriend() {
        context.insert(Friend(name: "New Friend"))
    }
}

#Preview {
    FriendList().modelContainer(SampleData.shared.modelContainer)
}
