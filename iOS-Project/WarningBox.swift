//
//  WarningBox.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import SwiftUI

struct WarningBox: View {
    let title: String
    let distance: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .semibold))
            Spacer()
            Text(distance)
                .foregroundColor(.gray)
                .font(.system(size: 13))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
