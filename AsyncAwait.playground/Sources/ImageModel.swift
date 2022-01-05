import Foundation
import UIKit

public struct ImageMetadata: Codable {
    public let name: String
    public let firstAppearance: String
    public let year: Int
}

public struct DetailedImage {
    public  let image: UIImage
    public  let metadata: ImageMetadata
    
    public init(
        image: UIImage,
        metadata: ImageMetadata
    ) {
        self.image = image
        self.metadata = metadata
    }
}

public enum ImageDownloadError: Error {
    case badImage
    case invalidMetadata
}


public struct Character {
    let id: Int
    
    public var metadata: ImageMetadata {
        get async throws {
            let metadata = try await downloadMetadata(for: id)
            return metadata
        }
    }
    
    public var image: UIImage {
        get async throws {
            return try await downloadImage(imageNumber: id)
        }
    }
}
