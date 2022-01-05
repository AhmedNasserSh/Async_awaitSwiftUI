import Foundation
import UIKit


public func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {
    async let image =  downloadImage(imageNumber: imageNumber)
    async let  metadata =  downloadMetadata(for: imageNumber)
    return try DetailedImage(image: await image, await metadata: metadata)
}

public func downloadImage(imageNumber: Int) async throws -> UIImage {
    try Task.checkCancellation()
    let imageUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(imageNumber).png")!
    let imageRequest = URLRequest(url: imageUrl)
    let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
    guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
        throw ImageDownloadError.badImage
    }
    return image
}

public func downloadMetadata(for id: Int) async throws -> ImageMetadata {
    try Task.checkCancellation()
    let metadataUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(id).json")!
    let metadataRequest = URLRequest(url: metadataUrl)
    let (data, metadataResponse) = try await URLSession.shared.data(for: metadataRequest)
    guard (metadataResponse as? HTTPURLResponse)?.statusCode == 200 else {
        throw ImageDownloadError.invalidMetadata
    }
    
    return try JSONDecoder().decode(ImageMetadata.self, from: data)
}
