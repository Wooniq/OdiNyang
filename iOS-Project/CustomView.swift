//
//  CustomView.swift
//  iOS-Project
//
//  Created by han on 6/13/25.
//

import SwiftUI

struct CustomView: View {
    @State private var selectedImageName: String = "catnews"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // 전체 배경색

            VStack(spacing: 0) {
                characterGrid
                    .padding(.bottom, 30)

                selectedCharacterImage
                    .padding(.bottom, 20)

                chatBubbles
            }
            .frame(maxHeight: 600)

            micButton
                .offset(x: 120, y: 30)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.bottom, 30)
        .frame(maxHeight: 710)
    }

    /// 캐릭터 선택 그리드
    private var characterGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(0..<8) { index in
                Button {
                    selectedImageName = "cat\(index)"
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay(
                            Image("cat\(index)")
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .frame(height: 80)
                }
            }
        }
    }

    /// 선택된 캐릭터 이미지 표시
    private var selectedCharacterImage: some View {
        Image(selectedImageName)
            .resizable()
            .scaledToFit()
            .frame(height: 140)
            .padding(10)
    }

    /// 말풍선 3개 정렬
    private var chatBubbles: some View {
        VStack(spacing: 10) {
            ChatBubble(imageName: "talk1", alignment: .leading)
            ChatBubble(imageName: "talk2", alignment: .trailing)
            ChatBubble(imageName: "talk3", alignment: .leading)
        }
    }

    /// 마이크
    private var micButton: some View {
        Image("mic")
            .resizable()
            .frame(width: 80, height: 80)
    }
}

// 말풍선 뷰
struct ChatBubble: View {
    var imageName: String
    var alignment: HorizontalAlignment = .leading

    var body: some View {
        HStack {
            if alignment == .leading {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270)
                Spacer()
            } else {
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270)
            }
        }
    }
}

#Preview {
    CustomView()
}
