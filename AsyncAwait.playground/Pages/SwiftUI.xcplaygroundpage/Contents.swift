import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
            Text(viewModel.text)
            
        }
        .onAppear {
            viewModel.getData()
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
