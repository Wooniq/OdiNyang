//
//  DangerZonePopupView.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import SwiftUI

struct DangerZonePopupView: View {
    let zone: DangerZone
    @Binding var selectedZone: DangerZone?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(zone.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    withAnimation {
                        selectedZone = nil
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding(6)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
            }

            Divider()

            HStack(spacing: 12) {
                Image(iconForType(zone.type))
                    .resizable()
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text("위험 유형: \(zone.type.description)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text("위치: \(zone.coordinate.latitude), \(zone.coordinate.longitude)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
    }
}
