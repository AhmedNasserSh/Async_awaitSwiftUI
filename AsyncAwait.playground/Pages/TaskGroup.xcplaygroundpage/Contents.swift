//: [Previous](@previous)

import Foundation
import UIKit

func downloadMultipleImagesWithMetadata(images: Int...) async throws -> [DetailedImage]{
    var imagesMetadata: [DetailedImage] = []
    try await withThrowingTaskGroup(of: DetailedImage.self, body: { group in
        for image in images {
            group.addTask {
                async let imageTask = downloadImageAndMetadata(imageNumber: image)
                return try await imageTask
            }
        }
        for try await image in group {
            imagesMetadata += [image]
        }
    })
    return imagesMetadata
}
