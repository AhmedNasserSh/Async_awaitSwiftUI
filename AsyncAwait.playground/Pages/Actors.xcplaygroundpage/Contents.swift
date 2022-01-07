//: [Previous](@previous)

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case badImage
}

actor ImageDownloader {
    private var cache: [URL: UIImage] = [:]
    
    func image(from url: URL) async throws -> UIImage {
        if let image = cache[url] {
            return image
        }
        
        let image = try await downloadImage(url: url)
        cache[url] = image
        return image
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

func downloadImages() async {
    let downloader = ImageDownloader()
    let imageURL = URL(string:  "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part3/3.png")!
    async let downloadedImage = downloader.image(from: imageURL)
    async let sameDownloadedImage = downloader.image(from: imageURL)
    var images = [UIImage?]()
    images += [try? await downloadedImage]
    images += [try? await sameDownloadedImage]
}

func startDownload() {
    Task.detached {
        await downloadImages()
    }
}

startDownload()
