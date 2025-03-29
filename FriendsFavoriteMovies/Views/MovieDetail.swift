//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Aiarsien on 24.03.2025.
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }
    
    var sortedFriends: [Friend] {
        movie.favoritedBy.sorted {
            //compares the first object to the next object in an array to sort all objects
        first, second in //it's like $0, $1
            first.name < second.name
        }
    }
    
    var body: some View {
        Form {
            TextField("Movie Title", text: $movie.title)
            
            DatePicker("Release date", selection: $movie.releaseDate, displayedComponents: .date)
            
            if !movie.favoritedBy.isEmpty { Section("Favorited by") {
                ForEach(sortedFriends) {friend in
                    Text(friend.name)
                }
                }
            } else {
                
            }
        }
        .navigationTitle(isNew ? "New Movie" : "Movie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            if isNew{
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        context.delete(movie)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        MovieDetail(movie: SampleData.shared.movie)
    }
}

#Preview {
    NavigationStack{
        MovieDetail(movie: SampleData.shared.movie, isNew:  true)
    }
}
