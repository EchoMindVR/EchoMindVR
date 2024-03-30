import SwiftUI


struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for Classes", text: $searchText)
            }
            .frame(maxWidth: 250, minHeight: 30)
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Button(action: {
                // Perform search
            }) {
                Image(systemName: "plus")
            }
        }
        
    }
}

