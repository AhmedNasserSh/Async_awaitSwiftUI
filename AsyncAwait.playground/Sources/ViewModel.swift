import Foundation
import UIKit
import Combine

@MainActor
public class ViewModel: ObservableObject {
    private let character: Character
    @Published public var image =  UIImage()
    @Published public var text = ""
    
    public init() {
        self.character = Character(id: 1)
    }
    
    public func getData() {
        Task {
            image = try! await character.image
            text = try! await character.metadata.name
        }
    }
}
