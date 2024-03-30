import SwiftUI

struct CardView: View {
    let classroom: Classroom
    @Binding var isPresentingClassroomDetail: Bool;
    
    var body: some View {
        NavigationLink(destination: CoursePageView(isPresentingClassroomDetail: $isPresentingClassroomDetail, classroom: classroom)){
            VStack(alignment: .leading) {
                Image(classroom.imageName) // Use your own images
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
                
                Text(classroom.name)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .padding([.top, .horizontal])
                    .foregroundColor(.white)
                
                Text(classroom.university)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .background(Color.gray.opacity(0.2)) // Change background color on hover
            .cornerRadius(12)
            .shadow(radius: 5)
            .hoverEffect()
        }
        .buttonStyle(PlainButtonStyle()) // Remove button-like interaction effects
    }
}
