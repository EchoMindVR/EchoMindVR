import SwiftUI


struct HomePage: View {
    
    @Binding var isLoggedIn: Bool;
    @State var query: String = "";
    
    let classes: [Classroom] = [
        // Add your classroom data here
        Classroom(name: "CS51 - Introduction to Generative AI", university: "Harvard University", imageName: "CS51"),
        Classroom(name: "ML 101 - Machine Learning Application", university: "University of Toronto", imageName: "ML101"),
        Classroom(name: "Entrepreneurship and Digital Business", university: "Ken Wu", imageName: "EN101"),
        Classroom(name: "ML 101 - Machine Learning Application", university: "University of Toronto", imageName: "ML101"),
        // ... more classrooms
    ]
    
    // Computed property to filter classes based on the query
    var filteredClasses: [Classroom] {
        if (query == "") {
            return classes
        }
        return classes.filter { classroom in
           classroom.name.localizedCaseInsensitiveContains(query) || classroom.university.localizedCaseInsensitiveContains(query)
        }
    }


    var body: some View {
        ZStack {
            // Content
            NavigationView {
                VStack {
                    Spacer()
                    Image(systemName: "person.crop.circle") // Profile image icon
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("Welcome Back! ")
                        .font(.largeTitle)
                    
                    Spacer()
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Log Out")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .frame(width: 180, height: 28)
                    .padding(.bottom, 100)
                    
                }

                VStack (alignment: .leading){
                    Text("My Classrooms 📚" + query)
                        .font(.system(size: 36))
                    HStack {
                        SearchBar(searchText: $query) // Custom search bar component
                        Spacer()
                    }
                    
                    
                    // Grid of cards
                    LazyVGrid(columns: [GridItem(.flexible(maximum: 440)), GridItem(.flexible(maximum: 440)), GridItem(.flexible(maximum: 440))],
                              alignment: .leading, spacing: 30) {
                        ForEach(filteredClasses) { classroom in
                            CardView(classroom: classroom)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 40)

            }
            
                
        }
    }
}
