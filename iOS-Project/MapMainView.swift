//
//  MapMainView.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapMainView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @StateObject private var locationManager = LocationManager()
    @State private var dangerZones: [DangerZone] = []
    @State private var sortedZones: [DangerZoneDistance] = []
    @State private var selectedZone: DangerZone? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 지도 뷰
                ZStack(alignment: .bottomTrailing) {
                    Map(coordinateRegion: $region, annotationItems: dangerZones) { zone in
                        MapAnnotation(coordinate: zone.coordinate) {
                            Button {
                                selectedZone = zone
                            } label: {
                                Image(iconForType(zone.type))
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }
                    .frame(height: 550)
                    .cornerRadius(20)
                    .overlay(
                        Image("pin")
                            .resizable()
                            .frame(width: 35, height: 35)
                    )

                    // 위치 이동 버튼
                    Button {
                        withAnimation {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833),
                                span: region.span
                            )
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 30))
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }

                // 하단 리스트
                VStack(spacing: 3) {
                    if sortedZones.isEmpty {
                        Text("위험 지역 정보를 불러오는 중...")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else {
                        ForEach(sortedZones.prefix(3)) { entry in
                            let km = String(format: "%.1fkm", entry.distance / 1000)
                            WarningBox(title: entry.zone.title, distance: km)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 30)
            }

            // 팝업
            if let selected = selectedZone {
                DangerZonePopupView(zone: selected, selectedZone: $selectedZone)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedZone)
            }
        }
        .onAppear {
            dangerZones = MockData.dangerZones
            let fallbackLocation = locationManager.lastLocation ?? CLLocation(latitude: 37.554722, longitude: 126.970833)
            sortedZones = dangerZones.map {
                let dist = fallbackLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))
                return DangerZoneDistance(zone: $0, distance: dist)
            }
            .sorted { $0.distance < $1.distance }
        }
        .onChange(of: locationManager.lastLocation) { newLocation in
            guard let location = newLocation else { return }
            sortedZones = dangerZones.map {
                let dist = location.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))
                return DangerZoneDistance(zone: $0, distance: dist)
            }
            .sorted { $0.distance < $1.distance }
        }
    }
}
