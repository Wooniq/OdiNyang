//
//  OnboardingView.swift
//  iOS-Project
//
//  Created by han on 6/14/25.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

struct OnboardingView: View {
    @State private var goToCustom = false
    var onFinish: (_ selectedTab: TopTab) -> Void
    
    var body: some View {
        ZStack {
            Image("first")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Kakao
                Button {
                    if (UserApi.isKakaoTalkLoginAvailable()) {
                        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                            if let error = error {
                                print("카카오톡 로그인 실패: \(error.localizedDescription)")
                            } else {
                                print("카카오톡 로그인 성공")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onFinish(.score)
                                }
                            }
                        }
                    } else {
                        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                            if let error = error {
                                print("카카오계정 로그인 실패: \(error.localizedDescription)")
                            } else {
                                print("카카오계정 로그인 성공")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onFinish(.score)
                                }
                            }
                        }
                    }
                } label: {
                    Image("kakao")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }


                // Google
                Button {
                    guard let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                        .first else {
                            print("rootViewController not found")
                            return
                    }

                    GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
                        if let error = error {
                            print("Google 로그인 실패: \(error.localizedDescription)")
                            return
                        }

                        guard let user = result?.user else {
                            print("사용자 정보 없음")
                            return
                        }

                        print("Google 로그인 성공")
                        print("이름: \(user.profile?.name ?? "-")")
                        print("이메일: \(user.profile?.email ?? "-")")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onFinish(.score)
                        }
                    }
                } label: {
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                
                // 냥포터 바로가기 버튼
                Button {
                    onFinish(.custom)
                } label: {
                    Image("custompage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
            }
            .padding(.bottom, 170)
        }
    }
}

#Preview {
    OnboardingView { _ in }
}
