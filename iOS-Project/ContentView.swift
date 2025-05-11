//
//  ContentView.swift
//  iOS-Project
//
//  Created by han on 5/12/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapMainView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833), // 서울역
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            // 배경 이미지
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 탭바
                HStack(spacing: 5) {
                    ForEach(["map", "direction", "score", "custom"], id: \.self) { icon in
                        Image(icon)
                            .resizable()
                            .frame(width: 36, height: 36)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .offset(y: -20)
                .offset(x: -5)
                .padding(.top, 80)

                Spacer()

                // 지도
                ZStack {
                    Map(coordinateRegion: $region)
                        .frame(height: 600)
                        .cornerRadius(20)
                        .offset(y: -20)
                        .offset(x: -5) // ← 왼쪽으로 20pt 이동
                        .overlay(
                            // 중앙 고양이 발바닥
                            Image("pin")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 35, height: 35)
                        )

                    // 내 위치로 이동 버튼
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                locationManager.requestLocation()
                                if let userLocation = locationManager.lastLocation {
                                    region.center = userLocation.coordinate
                                }
                            }) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 30))
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(.trailing, 16)
                            .padding(.bottom, 10)
                            .offset(y: -20)
                        }
                    }
                }

                // 하단 위험 알림
                VStack(spacing: 3) {
                    WarningBox(title: "싱크홀 발생 위험 지역", distance: "0.5km")
                    WarningBox(title: "낙사 사고 다발 지역", distance: "1.7km")
                }
                .padding(.bottom, 50)
                .offset(y: -10)
                .offset(x: -5)
            }
            .padding(.horizontal, 16)
        }
    }
}

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

#Preview("지도화면") {
    MapMainView()
}
