//
//  ViewModel.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 05.12.2022.
//
import SwiftUI

final class ViewModel: ObservableObject {
    static let shared: ViewModel = .init()

    @Published var selectedImage = ViewModel.defaultImage
    @Published var avatarImage = ViewModel.defaultAvatar
    @Published var isPresentingImagePicker = false
    private static let defaultAvatar = UIImage(systemName: "figure.walk.circle.fill")!
    private static let defaultImage = UIImage(named: "Unknown")!
    var userName: String? { didSet { getImage() } }

    private(set) var sourceType: ImagePicker.SourceType = .camera
    private func scaleAvatar(image: UIImage) -> UIImage {
        let targetSize = CGSize(width: 32, height: 32)
        let scaleFactor = min(targetSize.width / image.size.width,
                              targetSize.height / image.size.height)
        let scaledImageSize = CGSize(width: image.size.width * scaleFactor,
                                     height: image.size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }

    func getImage() {
        var image: UIImage?
        if let name = userName {
            let picturesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = picturesPath.appendingPathComponent(name, conformingTo: .png).relativePath
            if let data = FileManager.default.contents(atPath: path) {
                image = UIImage(data: data)
            }
        }
        selectedImage = image ?? ViewModel.defaultImage
    }

    func setImage() {
        avatarImage = scaleAvatar(image: selectedImage)
        guard let data = selectedImage.pngData(),
              let name = userName else { return }
        let picturesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = picturesPath.appendingPathComponent(name, conformingTo: .png)
        do {
            try data.write(to: url, options: .atomic)
        } catch let err {
            print("File write error", err)
        }
    }

    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
    }

    func takePhoto() {
        sourceType = .camera
        isPresentingImagePicker = true
    }

    func didSelectImage(_ image: UIImage?) {
        selectedImage = image ?? ViewModel.defaultImage
        setImage()
        isPresentingImagePicker = false
    }
}
