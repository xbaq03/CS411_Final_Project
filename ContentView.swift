import SwiftUI

extension Color {
    static let themeYellow = Color(hex: "#F28C0F")
    static let themeOrange = Color(hex: "#F24E29")
    static let themePeach = Color(hex: "#F2BFB3")
    static let themeRed = Color(hex: "#73322C")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let year: Int
    var image_url: String? // Add the image URL as an optional string
    let tmdb_type: String
}


struct StreamingInfo: Codable {
    let name: String
    // Include any other properties you want from the JSON response
}

struct StreamingServiceResponse: Codable {
    let services: [StreamingInfo]
}

struct ApiResponse: Codable {
    var titles: [Movie]
}
struct SearchResponse: Codable {
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let name: String
    let image_url: String?
}

// Assume you have a Genre struct like this
struct Genre: Identifiable, Hashable {
    let id: Int
    let name: String
}


// Sample genres data - this would come from your actual genres source
let genresData = [
    Genre(id: 1, name: "Action"),
    Genre(id: 2, name: "Adventure"),
    Genre(id: 3, name: "Animation"),
    Genre(id: 31, name: "Biography"),
    Genre(id: 4, name: "Comedy"),
    Genre(id: 5, name: "Crime"),
    Genre(id: 6, name: "Documentary"),
    Genre(id: 7, name: "Drama"),
    Genre(id: 8, name: "Family"),
    Genre(id: 9, name: "Fantasy"),
    Genre(id: 10, name: "History"),
    Genre(id: 11, name: "Horror"),
    Genre(id: 21, name: "Kids"),
    Genre(id: 12, name: "Music"),
    Genre(id: 32, name: "Musical"),
    Genre(id: 13, name: "Mystery"),
    Genre(id: 22, name: "News"),
    Genre(id: 14, name: "Romance"),
    Genre(id: 15, name: "Science Fiction"),
    Genre(id: 17, name: "Thriller"),
    Genre(id: 38, name: "TV Movie"),
    Genre(id: 18, name: "War"),
    Genre(id: 19, name: "Western")
]


struct ContentView: View {
    
    @State private var movieTitles = [Movie]()
    @State private var selectedGenre: Genre? = nil
    @State private var showingGenrePicker = false
    @State private var shouldNavigate = false // This will control the navigation
    @State private var showingAboutView = false

    
    
    var limit = 20
    
    var body: some View {
        
        
        NavigationStack {
            ZStack{
                Color.themePeach.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Button(action: {
                        Task {
                            let success = await signInWithGoogle()
                            if success {
                                // Handle successful sign in
                            } else {
                                // Handle failed sign in
                            }
                        }
                    }) {
                        Text("Sign in with Google")
                            .foregroundColor(.black) // or whatever color you prefer
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(alignment: .leading) {
                                Image("Google")
                                    .frame(width: 30, alignment: .center)
                            }
                    }
                    .buttonStyle(.bordered)


                    Spacer()
                    Button("Select a Genre") {
                        showingGenrePicker = true
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Large tap area
                    .background(Color(hex: "#73322C")) // Solid background color
                    .foregroundColor(.white) // White text color
                    .font(.headline) // Large, bold font
                    .cornerRadius(10) // Rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2) // White stroke
                    )
                    .padding(.horizontal) // Horizontal padding
                    .shadow(radius: 5) // Subtle shadow for depth
                    
                    .sheet(isPresented: $showingGenrePicker) {
                        GenrePickerView(genres: genresData, selectedGenre: $selectedGenre, showing: $showingGenrePicker)
                    }
                    
                    
                    
                    
                    
                    if let genre = selectedGenre {
                        Text("Selected Genre: \(genre.name)")
                            .font(.headline.weight(.semibold)) // Changed from .title2 to .headline for a smaller size
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex: "#7D4E4A")) // A warm gray that should complement your color scheme
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(5)

                        
                    }
                    
                    Button(action: {
                        if let genre = selectedGenre {
                            Task {
                                await fetchMovies(genre: genre.id)
                                shouldNavigate = true
                            }
                        }
                    }) {
                        
                        Button("Search") {
                            if let genre = selectedGenre {
                                Task {
                                    await fetchMovies(genre: genre.id)
                                    shouldNavigate = true
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Large tap area
                        .background(Color.themeYellow) // Apply the solid background color
                        .foregroundColor(.white) // White text color
                        .font(.headline) // Large, bold font
                        .cornerRadius(10) // Rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2) // White stroke with desired line width
                        )
                        .padding(.horizontal) // Horizontal padding
                        .shadow(radius: 5) // Subtle shadow for depth

                        .disabled(selectedGenre == nil) // Disable if no genre is selected
                        
                        NavigationLink("", destination: MoviesListView(movies: movieTitles), isActive: $shouldNavigate)
                            .hidden()
                        Spacer()
                        Button("About") {
                            showingAboutView = true
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "#F2695C")) // Use the hex color for the background
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2) // White stroke
                        )
                        .padding()

                        .sheet(isPresented: $showingAboutView) {
                            AboutView()
                        }
                        
                        
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Image(systemName: "film")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white) // Set film icon to white
                                    Text("Movie LookUp")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white) // Set text to white
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5) // Add vertical padding for a better look
                                .background(Color(hex: "#F24E29")) // Use the hex color for the background
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 3, x: 0, y: 2)
                            }
                        }

                        
                        Spacer()
                    }
                    Spacer()
                }
                
            }
        }
    }
        
        func fetchMovies(genre: Int) async {
            let apiKey = "kt0QoiIJkBX5duxqbpC8i4kzV2SJJQaOH5zkly4N"
            let urlString = "https://api.watchmode.com/v1/list-titles/?apiKey=\(apiKey)&genres=\(genre)&limit=\(limit)"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                var decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                decodedResponse.titles = decodedResponse.titles.filter { $0.tmdb_type == "movie" }
                       DispatchQueue.main.async {
                           self.movieTitles = decodedResponse.titles
                       }
                
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
        
    struct GenrePickerView: View {
        var genres: [Genre]
        @Binding var selectedGenre: Genre?
        @Binding var showing: Bool

        var body: some View {
            NavigationView {
                List(genres) { genre in
                    Button(action: {
                        selectedGenre = genre
                        showing = false
                    }) {
                        Text(genre.name)
                            .foregroundColor(Color.themeRed) // Changed text color to #73322C
                    }
                }
                .listStyle(PlainListStyle()) // Add this to remove list lines
                .navigationTitle("Pick a Genre")
                .background(Color.themePeach) // Set the background color to #F2BFB3
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showing = false
                        }
                        .foregroundColor(Color.themeRed) // Color for the "Done" button
                      
                    }
                }
            }
        }
    }

        
        struct MoviesListView: View {
            var movies: [Movie]
            
            var body: some View {
                List(movies) { movie in
                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                        Text(movie.title).italic()
                        .foregroundColor(Color.themeRed)
                    }
                }
            }
        }
    struct AboutView: View {
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("About Movie LookUp")
                        .font(.title)
                        .bold()

                    Text("Created by: [Badr, Albert, Roaa, Dana]")
                        .font(.headline)

                    Text("Purpose:")
                        .font(.headline)
                    Text("Movie LookUp aims to help users find information about movies, including streaming platforms and overviews without spoilers.")

                    Text("API Credits:")
                        .font(.headline)
                    Text("WatchMode API: For streaming information.")
                    Text("TMDB API: For movie overviews")

                    Spacer()
                }
                .padding()
                .navigationBarTitle("About", displayMode: .inline)
            }
            
        }
    }
    struct MovieDetailsView: View {
        let movie: Movie
        @State private var movieImageURL: URL?
        @State private var streamingPlatforms: [StreamingInfo] = []
        @State private var tmdbOverview: String?
        
        var body: some View {
            ScrollView{
                VStack {
                    Spacer()
                    Text(movie.title)
                        .font(.title)
                    
                    // Display the image if the URL has been loaded
                    if let movieImageURL = movieImageURL {
                        AsyncImage(url: movieImageURL) { phase in
                            if let image = phase.image {
                                image .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Add rounded corners
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10) // Add a border around the image
                                            .stroke(Color.themePeach, lineWidth: 3) // Use the peach color for the border
                                    )
                                    .shadow(color: Color.themeRed.opacity(0.7), radius: 10, x: 0, y: 10) // Add a deep red shadow for depth
                                    .padding(.all, 5) // Add some padding around the image
                                    .background(Color.themePeach.opacity(0.3)) // Add a subtle peach background for a glow effect
                                    .cornerRadius(10) // Ensure the background also has rounded corners
                            } else if phase.error != nil {
                                Text("Error loading image").foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 200, height: 300)
                    } else {
                        // Display a placeholder while the image is loading
                        ProgressView().onAppear {
                            Task {
                                await fetchImageURL()
                            }
                        }
                    }
                    Text("Year: \(String(movie.year))") // This will ensure no formatting like commas are added
                        .font(.headline)
                        .foregroundColor(Color.themeRed) // Use the theme red color for text
                        .padding(4)
                        .background(Color.themePeach.opacity(0.2)) // A subtle background color from your theme
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.themeYellow, lineWidth: 1) // Add a border with the theme yellow color
                        )

                    if let overview = tmdbOverview {
                        Text(overview)
                            .padding()
                            .font(.body) // Adjust font as needed
                            .foregroundColor(Color.themeRed) // Text color from your theme
                            .background(Color.themePeach.opacity(0.2)) // Light background for readability
                            .cornerRadius(8) // Soften the corners of the background
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.themeYellow, lineWidth: 1) // Border with a theme color
                            )
                            .padding(.horizontal, 10) // Additional horizontal padding for better aesthetics

                    } else {
                        Text("Fetching overview...").padding().onAppear {
                            fetchTmdbOverview()
                        }
                    }
                    if !streamingPlatforms.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Available on:")
                                .font(.headline)
                                .foregroundColor(Color.themeRed) // Theme color for the header
                                .padding(.top)
                            ForEach(streamingPlatforms, id: \.name) { platform in
                                Text(platform.name)
                                    .foregroundColor(Color.white) // White text for better readability
                                    .padding(5)
                                    .background(Color.themeOrange) // Orange background from the theme
                                    .cornerRadius(8) // Rounded corners for each platform name
                                    .padding(.bottom, 2)
                            }
                        }
                    } else {
                        Text("Not Available...")
                            .foregroundColor(Color.themeRed) // Theme color for the text
                            .font(.subheadline) // A bit smaller font size for 'Not Available...'
                            .padding() // Padding for spacing
                            .background(Color.themePeach.opacity(0.2)) // Light background for 'Not Available...'
                            .cornerRadius(8) // Match rounded corners
                            .onAppear {
                                Task {
                                    await fetchStreamingPlatforms()
                                }
                            }
                    }

                    
                    Spacer()
                    Spacer()
                }
                
            }
            
            .padding()
            
            
        }
    
            
            func fetchImageURL() async {
                let apiKey = "kt0QoiIJkBX5duxqbpC8i4kzV2SJJQaOH5zkly4N"
                let searchQuery = movie.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                let searchURLString = "https://api.watchmode.com/v1/autocomplete-search/?apiKey=\(apiKey)&search_value=\(searchQuery)&search_type=1"
                
                guard let searchURL = URL(string: searchURLString) else { return }
                
                do {
                    let (searchData, _) = try await URLSession.shared.data(from: searchURL)
                    if let decodedSearchResponse = try? JSONDecoder().decode(SearchResponse.self, from: searchData),
                       let imageURLString = decodedSearchResponse.results.first?.image_url,
                       let imageURL = URL(string: imageURLString) {
                        DispatchQueue.main.async {
                            self.movieImageURL = imageURL
                        }
                    }
                } catch {
                    print("Failed to fetch image URL: \(error)")
                }
            }
            
            func fetchStreamingPlatforms() async {
                // Replace with the correct endpoint and use the movie's specific identifier
                let apiKey = "kt0QoiIJkBX5duxqbpC8i4kzV2SJJQaOH5zkly4N"
                let streamingURLString = "https://api.watchmode.com/v1/title/\(movie.id)/sources/?apiKey=\(apiKey)"
                
                guard let streamingURL = URL(string: streamingURLString) else {
                    print("Invalid URL for streaming platforms")
                    return
                }
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: streamingURL)
                    let platformsResponse = try JSONDecoder().decode([StreamingInfo].self, from: data)
                    
                    // Use a Set to hold unique platform names
                    var uniquePlatforms = Set<String>()
                    for platform in platformsResponse {
                        uniquePlatforms.insert(platform.name)
                    }
                    
                    // Convert the Set back to an Array for SwiftUI ForEach compatibility
                    let uniquePlatformsArray = Array(uniquePlatforms)
                    
                    DispatchQueue.main.async {
                        self.streamingPlatforms = uniquePlatformsArray.map { name in
                            StreamingInfo(name: name) // Create a new StreamingInfo for each unique name
                        }
                    }
                } catch {
                    print("Failed to fetch streaming platforms: \(error)")
                }
            }
            
            
            func fetchTmdbOverview() {
                let movieTitleQuery = movie.title.replacingOccurrences(of: " ", with: "+")
                let tmdbURL = "https://api.themoviedb.org/3/search/movie?query=\(movieTitleQuery)&api_key=ff2177e754708c4f9a19406cf4c8df37"
                
                guard let url = URL(string: tmdbURL) else {
                    print("Invalid URL")
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let results = jsonResult["results"] as? [[String: Any]],
                           let overview = results.first?["overview"] as? String {
                            DispatchQueue.main.async {
                                self.tmdbOverview = overview
                            }
                        }
                    } catch {
                        print("Failed to fetch TMDb overview: \(error)")
                    }
                }.resume()
            }
        }
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    }

