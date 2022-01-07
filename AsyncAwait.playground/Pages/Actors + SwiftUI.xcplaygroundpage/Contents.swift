//: [Previous](@previous)

import Foundation
import UIKit
import Combine
import SwiftUI

enum ImageDownloadError: Error {
    case badImage
}

actor ImageDownloader {
    private enum ImageStatus {
         case downloading(_ task: Task<UIImage, Error>)
         case downloaded(_ image: UIImage)
     }
     
     private var cache: [URL: ImageStatus] = [:]
     
     func image(from url: URL) async throws -> UIImage {
         if let imageStatus = cache[url] {
             switch imageStatus {
             case .downloading(let task):
                 return try await task.value
             case .downloaded(let image):
                 return image
             }
         }
         
         let task = Task {
             try await downloadImage(url: url)
         }
         
         cache[url] = .downloading(task)
         
         do {
             let image = try await task.value
             cache[url] = .downloaded(image)
             return image
         } catch {
             // If an error occurs, we will evict the URL from the cache
             // and rethrow the original error.
             cache.removeValue(forKey: url)
             throw error
         }
     }
     
    
    private func downloadImage(url: URL) async throws -> UIImage {
        let imageRequest = URLRequest(url: url)
        let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return image
    }
}



@MainActor
class ViewModelActor: ObservableObject {
    @Published var images = [UIImage?]()
    
    func downloadImages() async {
        let downloader = ImageDownloader()
        let imageURL = URL(string:  "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part3/3.png")!
        async let downloadedImage = downloader.image(from: imageURL)
        async let sameDownloadedImage = downloader.image(from: imageURL)
        images += [try? await downloadedImage]
        images += [try? await sameDownloadedImage]
    }
    
    func startDownload() {
        Task.detached {
            await self.downloadImages()
        }
    }

}


struct ContentView: View {
    @StateObject var viewModel = ViewModelActor()
    
    var body: some View {
        List {
            ForEach(viewModel.images, id: \.self)  { image in
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
        .padding()
        .onAppear {
            viewModel.startDownload()
        }
    }
}
