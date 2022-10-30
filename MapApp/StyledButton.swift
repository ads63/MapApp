//
//  StyledButton.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 23.10.2022.
//

import SwiftUI

struct StyledButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .padding()
            .background(.black.opacity(0.5))
            .foregroundColor(.white)
            .font(.caption)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
    }
}

struct StyledButton_Previews: PreviewProvider {
    static var previews: some View {
        StyledButton(title: "", action: {})
    }
}
