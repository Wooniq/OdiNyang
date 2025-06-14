//
//  ContentView.swift
//  iOS-Project
//
//  Created by han on 5/12/25.
//

import SwiftUI

/// 상단 탭의 항목들 정의
enum TopTab: String, CaseIterable {
    case map, direction, score, custom
}

struct ContentView: View {
    /// 현재 선택된 탭 상태
    @State private var selectedTab: TopTab = .score

    var body: some View {
        ZStack {
            // 탭에 따른 배경 이미지
            backgroundView(for: selectedTab)

            // 선택된 탭의 메인 콘텐츠
            contentView(for: selectedTab)
                .padding(.horizontal, 16)
                .padding(.top, 100)

            // 고정 상단 탭바
            topTabBar
                .ignoresSafeArea(edges: .top)
                .zIndex(10) // 항상 위에 고정
        }
    }

    /// 탭에 따라 다른 배경 이미지를 보여줌
    @ViewBuilder
    private func backgroundView(for tab: TopTab) -> some View {
        Image(tab == .score ? "scoreBG" : "bg")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    /// 탭에 따라 서로 다른 콘텐츠 뷰를 보여줌
    @ViewBuilder
    private func contentView(for tab: TopTab) -> some View {
        switch tab {
        case .map:
            MapMainView()
        case .direction:
            DirectionView()
        case .score:
            SafetyScoreView()
        case .custom:
            CustomView()
        @unknown default:
            Text("Unknown Tab")
        }
    }

    /// 상단 탭바 뷰 정의
    private var topTabBar: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(TopTab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Image(tab.rawValue)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .padding(10)
                            .background(
                                Color.white.opacity(tab == selectedTab ? 0.4 : 0.2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(.horizontal, 25)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
            )
            .padding(.top, 50) // 상단 safe area 고려

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
