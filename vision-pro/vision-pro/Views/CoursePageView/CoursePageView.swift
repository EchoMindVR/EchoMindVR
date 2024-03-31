
import SwiftUI

// The detail view for a Classroom
struct CoursePageView: View {
    
    @Binding var isPresentingClassroomDetail: Bool;
    
    let classroom: Classroom
    let lessons: [Lesson] = [
        // Populate with real data
        Lesson(title: "Understanding the Basics", date: Date()),
        Lesson(title: "Exploring Deep Learning in Generative AI Models", date: Date()),
        Lesson(title: "Creative Applications", date: Date()),
        Lesson(title: "Ethical Considerations and the Future of AI", date: Date()),
    ]
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // The content and layout of your header go here
                // You can use an HStack for the title and university name
                VStack(alignment: .leading, spacing: 8) {
                    Text(classroom.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(classroom.university)
                        .font(.subheadline)
                }
                Spacer()
                // You can add your course, content, learn, assignments buttons here
            }
            .padding()
            
            Divider()
            
            // The section for recent lessons or items
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent")
                    .font(.headline)
                    .padding(.leading)
                ForEach(lessons) { lesson in
                    HStack {
                        NavigationLink(destination: ChatView()) {
                            Text(lesson.title)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(dateFormatter.string(from: lesson.date))
                                .font(.footnote)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                        }
                       
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }
            
            Spacer()
            
        }
        .navigationBarTitle(Text("CS51 - Introduction to Generative AI"), displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {}) {
                Image(systemName: "person.crop.circle") // User profile icon
            },
            trailing: Button(action: {}) {
                Text("Log Out")
            }
        )
        .padding(40)
    }
}
