//
//  SafetyScoreView.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import SwiftUI

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let imageName: String
}

struct SafetyScoreView: View {
    @State private var selectedNews: NewsItem? = nil

    let newsList: [NewsItem] = [
        NewsItem(title: "오늘의 우리동네 위험 뉴스 보기", summary: "[속보] 귀여운 고양이 출몰해 주민 여럿 심쿵사...", imageName: "cat"),
        NewsItem(title: "오늘의 우리동네 위험 뉴스 보기", summary: "[사고] 동대문구 공사장 인근 붕괴로 인한 도로 통제", imageName: "construction"),
        NewsItem(title: "오늘의 우리동네 위험 뉴스 보기", summary: "[화재] 종로구 주택가 화재 발생, 인명 피해는 없어", imageName: "fire")
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 상단 텍스트 정보
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                        Text("서울역 15번출구")
                            .foregroundColor(.accentColor)
                            .font(.subheadline)
                            .bold()
                    }

                    VStack(spacing: 0) {
                        Text("오늘 우리동네")
                            .font(.title)
                            .foregroundColor(.black)
                            .bold()
                        HStack(spacing: 0) {
                            Text("안전 수치는 ")
                                .font(.title)
                                .foregroundColor(.black)
                                .bold()
                            Text("73")
                                .font(.title)
                                .foregroundColor(.green)
                                .bold()
                            Text("입니다.")
                                .font(.title)
                                .foregroundColor(.black)
                                .bold()
                        }
                        .font(.title3)

                        HStack(spacing: 10) {
                            Image(systemName: "thermometer")
                                .foregroundColor(.blue)
                            Text("23℃")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        }
                        // 위험 요소 건수
                        HStack(spacing: 16) {
                            Text("화재: 0건")
                            Text("교통사고: 3건")
                            Text("싱크홀: 1건")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    }
                    .padding(.top, 40)
                }

                Spacer()

                // 뉴스 카드
                VStack(spacing: 12) {
                    ForEach(newsList) { news in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.8))
                            .frame(height: 80)
                            .overlay(
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(news.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text(news.summary)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal)
                            )
                            .onTapGesture {
                                selectedNews = news
                            }
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)

            // 팝업 오버레이
            if let news = selectedNews {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedNews = nil
                    }

                VStack(spacing: 16) {
                    Image("catnews")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.top)

                    Text(news.title)
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text(news.summary)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: {
                        selectedNews = nil
                    }) {
                        Text("닫기")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding(40)
            }
        }
    }
}

struct SafetyScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyScoreView()
    }
}
