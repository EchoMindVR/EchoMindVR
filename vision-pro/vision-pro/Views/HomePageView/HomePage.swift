import SwiftUI


let dummyText = """
    CS51 is a beginner-friendly course aimed at demystify
    ing the mechanics and applications of generative
    artificial intelligence. Students will delve into key
    concepts such as neural networks, machine learning,
    and models like GPT and DALL-E. Through lectures,
    hands-on projects, and discussions, learners will
    explore how these technologies create new content,
    their real-world applications, and ethical
    considerations. The course aims to equip students
    with a foundational understanding of generative AI,
    enabling them to conceptualize and assess
    AI-generated content critically. No prior AI knowledge
    is required, making it perfect for those curious about
    entering the AI field.
"""

struct HomePage: View {
    
    @Binding var isPresentingClassroomDetail: Bool;
    @Binding var isLoggedIn: Bool;
    @Binding var userName: String;
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
            NavigationView {
                VStack {
                    Spacer()
                    Image(systemName: "person.crop.circle") // Profile image icon
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("Welcome Back! ")
                        .font(.largeTitle)
                    Text(userName)
                        .font(.title)
                    
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
                            CardView(classroom: classroom, isPresentingClassroomDetail: $isPresentingClassroomDetail)
                        }
                    }
                              .padding(.top, 20)
                }
                .padding(.horizontal, 40)
                
            }
        }
    }
}
