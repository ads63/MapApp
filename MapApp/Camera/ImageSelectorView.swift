//
//  ImageSelectorView.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 04.12.2022.
//

import SwiftUI

struct ImageSelectorView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {
            imageView(for: viewModel.selectedImage)
            Button(action: viewModel.takePhoto, label: {
                Text("New Photo")
            })
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker, content: {
            ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
        })
    }

    @ViewBuilder
    func imageView(for image: UIImage?) -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        else {
            Text("No image selected")
        }
    }
}

// struct ImageSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSelectorView()
//    }
// }
