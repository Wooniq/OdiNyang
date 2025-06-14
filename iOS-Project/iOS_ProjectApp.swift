//
//  iOS_ProjectApp.swift
//  iOS-Project
//
//  Created by han on 5/12/25.
//

import SwiftUI
import KakaoSDKCommon
import GoogleSignIn

@main
struct iOS_ProjectApp: App {
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "49354a32829a8c403e85cfdfedc33517")
        
        // Google SDK 초기화
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "527352665551-0j33i3doede5bpuuatijrq54gr2ltjnd.apps.googleusercontent.com"
        )
    }
    
    @State private var isOnboardingDone = false
    @State private var initialTab: TopTab = .map

    var body: some Scene {
        WindowGroup {
            if isOnboardingDone {
                // selectedTab은 ContentView 내부에서 관리되므로 여기선 전달하지 않음
                ContentView()
            } else {
                // 온보딩 완료 시 상태 갱신
                OnboardingView { selectedTab in
                    initialTab = selectedTab
                    isOnboardingDone = true
                }
            }
        }
    }
}
