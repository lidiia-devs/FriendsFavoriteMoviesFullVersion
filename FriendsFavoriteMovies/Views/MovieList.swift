//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by Aiarsien on 24.03.2025.
//

import SwiftUI
import SwiftData

struct MovieList: View {
    //References the Movie.title, not copying
    @Query private var movies: [Movie]
    @Environment(\.modelContext) private var context
    
    init(titleFilter: String = "") {
        let predicate = #Predicate<Movie> {
            movie in
            titleFilter.isEmpty || movie.title.localizedStandardContains(titleFilter)
        }
        _movies = Query(filter: predicate, sort: \Movie.title)
    }
    
    @State private var newMovie: Movie?

    var body: some View {
        NavigationSplitView{
            List {
                ForEach(movies) { movie in
                    NavigationLink(movie.title){
                        MovieDetail(movie: movie)
                    }
                }
                .onDelete(perform: deleteMovies(indexes: ))
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem {
                    Button("Add Movie", systemImage: "plus", action: addMovie)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $newMovie){ movie in
                NavigationStack {
                    MovieDetail(movie: movie, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a movie")
                .navigationTitle("Movie")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addMovie() {
        let newMovie = Movie(title: "", releaseDate: .now)
        context.insert(newMovie)
        self.newMovie = newMovie
    }
    
    private func deleteMovies(indexes: IndexSet) {
        for index in indexes {
            context.delete(movies[index])
        }
    }
}

#Preview {
    MovieList().modelContainer(SampleData.shared.modelContainer)
}

#Preview("Filtered") {
    MovieList(titleFilter: "tr").modelContainer(SampleData.shared.modelContainer)
}
