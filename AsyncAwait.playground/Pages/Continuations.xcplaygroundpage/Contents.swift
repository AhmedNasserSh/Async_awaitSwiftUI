import Foundation
import UIKit


func downloadImageAndMetadata(
    imageNumber: Int,
    completionHandler: @escaping (_ image: DetailedImage?, _ error: Error?) -> Void
) {
    let imageUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(imageNumber).png")!
    let imageTask = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
        guard let data = data, let image = UIImage(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
            completionHandler(nil, ImageDownloadError.badImage)
            return
        }
        let metadataUrl = URL(string: "https://www.andyibanez.com/fairesepages.github.io/tutorials/async-await/part1/\(imageNumber).json")!
        let metadataTask = URLSession.shared.dataTask(with: metadataUrl) { data, response, error in
            guard let data = data, let metadata = try? JSONDecoder().decode(ImageMetadata.self, from: data),  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completionHandler(nil, ImageDownloadError.invalidMetadata)
                return
            }
            let detailedImage = DetailedImage(image: image, metadata: metadata)
            completionHandler(detailedImage, nil)
        }
        metadataTask.resume()
    }
    imageTask.resume()
}


func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {
    return try await withCheckedThrowingContinuation({
        (continuation: CheckedContinuation<DetailedImage, Error>) in
        downloadImageAndMetadata(imageNumber: imageNumber) { image, error in
            if let image = image {
                continuation.resume(returning: image)
            }else {
                continuation.resume(throwing: error!)
            }
        }
        
    })
}


Task {
    if let imageDetail = try? await downloadImageAndMetadata(imageNumber: 1) {
        print("\(imageDetail.metadata.name) (\(imageDetail.metadata.firstAppearance) - \(imageDetail.metadata.year))")
    }
}
