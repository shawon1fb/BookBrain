import SwiftUI

struct ContentView: View {
    @State private var selectedPage: Int? = 1
    @State private var llmModel = ""
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var isDetailVisible = true
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                SidebarView(selectedPage: $selectedPage)
            },
            detail: {
                AdaptiveSplitView(
                    isDetailVisible: $isDetailVisible,
                    mainContent: { MainContentView(isDetailVisible: $isDetailVisible) },
                    detailContent: { DetailView(llmModel: $llmModel) }
                )
            }
        )
        .toolbar {
            #if os(macOS)
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    withAnimation {
                        isDetailVisible.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.right")
                }
            }
            #else
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        isDetailVisible.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.right")
                }
            }
            #endif
        }
        .navigationTitle("Books")
        .background(Color.purple.opacity(0.2))
        .navigationSplitViewStyle(.prominentDetail)
    }
}

struct AdaptiveSplitView<MainContent: View, DetailContent: View>: View {
    @Binding var isDetailVisible: Bool
    let mainContent: () -> MainContent
    let detailContent: () -> DetailContent
    
    var body: some View {
        #if os(macOS)
        HSplitView {
            mainContent()
            if isDetailVisible {
                detailContent()
            }
        }
        #else
        HStack(spacing: 0) {
            mainContent()
            if isDetailVisible {
                detailContent()
                    .frame(maxWidth: UIScreen.main.bounds.width / 3)
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut, value: isDetailVisible)
            }
        }
        #endif
    }
}

struct SidebarView: View {
    @Binding var selectedPage: Int?
    
    var body: some View {
        List(1...4, id: \.self, selection: $selectedPage) { number in
            Text("\(number)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 1)
                )
                .listRowBackground(Color.mint.opacity(0.1))
        }
        .frame(minWidth: 200)
        .background(Color.mint.opacity(0.1))
    }
}

struct MainContentView: View {
    @Binding var isDetailVisible: Bool
    
    var body: some View {
        VStack {
            Text("Books page view")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct DetailView: View {
    @Binding var llmModel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("translated text")
                .font(.headline)
            
            Image(systemName: "atom")
                .font(.title)
            
            HStack {
                TextField("llm models", text: $llmModel)
                    #if os(macOS)
                    .textFieldStyle(.roundedBorder)
                    #else
                    .textFieldStyle(.rounded)
                    #endif
                
                Button("Regenerate") {
                    // Regenerate action
                }
                .buttonStyle(.bordered)
            }
            
            Text("Summary")
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 200)
        .background(Color.mint.opacity(0.1))
    }
}

#if os(iOS)
// Helper to ensure we use the correct text field style name on iOS
extension TextFieldStyle where Self == RoundedBorderTextFieldStyle {
    static var rounded: RoundedBorderTextFieldStyle {
        return .roundedBorder
    }
}
#endif
