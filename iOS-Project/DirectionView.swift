//
//  DirectionView.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Enum

enum RouteMode: String, CaseIterable {
    case shortest = "최단 경로"
    case safest = "안전 경로"
}

// MARK: - Constants

private enum Constants {
    static let dangerThreshold: Double = 50.0
    static let policeThreshold: Double = 100.0
    static let distancePenaltyUnit: Double = 50.0
}

// MARK: - Search Delegate Wrapper

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
}

// MARK: - Main View

struct DirectionView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchCompleter = MKLocalSearchCompleter()
    @StateObject private var searchCompleterDelegate = SearchCompleterDelegate()

    // 좌표 관련 상태
    let fixedStart = CLLocationCoordinate2D(latitude: 37.5663, longitude: 126.9779) // 서울시청
    @State private var destination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.582604, longitude: 127.009440) // 한성대
    @State private var destinationName: String = "한성대학교 정문"

    // 검색 상태
    @State private var searchQuery: String = ""

    // 지도 및 경로 상태
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5663, longitude: 126.9779),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var route: MKRoute?
    @State private var routeColor: UIColor = .systemBlue
    @State private var remainingDistance: CLLocationDistance = 0

    // 네비게이션 상태
    @State private var selectedMode: RouteMode = .shortest
    @State private var currentStepIndex: Int = 0
    @State private var steps: [MKRoute.Step] = []
    @State private var currentInstruction: String = ""

    var body: some View {
        ZStack {
            MapView(
                route: $route,
                region: $region,
                destination: destination,
                startLocation: fixedStart,
                routeColor: $routeColor
            )
            .id(routeColor.description) // 강제 리프레시 용도

            VStack(spacing: 0) {
                modePicker
                destinationSearchView
                Spacer()
                routeInfoPanel
            }
        }
        .onAppear {
            configureSearch()
            updateRoute(from: fixedStart)
        }
        .onChange(of: selectedMode) { _ in
            updateRoute(from: fixedStart)
        }
    }
}

// MARK: - View Components

extension DirectionView {
    private var modePicker: some View {
        Picker("", selection: $selectedMode) {
            ForEach(RouteMode.allCases, id: \.self) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }

    private var destinationSearchView: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("목적지를 검색하세요", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 16)
                .onChange(of: searchQuery) { newValue in
                    searchCompleter.queryFragment = newValue
                }

            if !searchCompleterDelegate.results.isEmpty {
                searchResultsView
            }
        }
    }

    private var searchResultsView: some View {
        List(searchCompleterDelegate.results, id: \.self) { result in
            VStack(alignment: .leading) {
                Text(result.title).font(.headline)
                Text(result.subtitle).font(.subheadline).foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                searchQuery = result.title
                searchCompleterDelegate.results = []
                searchForLocation(result)
            }
        }
        .listStyle(PlainListStyle())
        .frame(maxHeight: 200)
    }

    private var routeInfoPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🚶 출발지").font(.caption)
                Spacer()
                Text("서울시청").font(.caption2).foregroundColor(.gray)
            }
            HStack {
                Text("🏁 목적지").font(.caption)
                Spacer()
                Text(destinationName).font(.caption2).foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text("남은 거리:").font(.headline)
                Spacer()
                Text(String(format: "%.1f m", remainingDistance)).font(.headline)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}

// MARK: - Route Handling

extension DirectionView {
    private func configureSearch() {
        searchCompleter.delegate = searchCompleterDelegate
        searchCompleter.resultTypes = .address
    }

    func updateRoute(from start: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        request.requestsAlternateRoutes = true

        MKDirections(request: request).calculate { response, error in
            guard let routes = response?.routes, !routes.isEmpty else {
                print("경로 없음 또는 응답 실패")
                return
            }

            switch selectedMode {
            case .safest:
                handleSafestRoute(routes, from: start)
            case .shortest:
                if let shortest = routes.min(by: { $0.distance < $1.distance }) {
                    apply(route: shortest, from: start)
                    routeColor = .systemBlue
                }
            }
        }
    }

    private func handleSafestRoute(_ routes: [MKRoute], from start: CLLocationCoordinate2D) {
        let scoredRoutes = routes.map { route in
            let score = safetyScore(for: route)
            let weightedScore = score + Int(route.distance / 500)
            return (route, weightedScore)
        }

        if let (safestRoute, _) = scoredRoutes.min(by: { $0.1 < $1.1 }) {
            apply(route: safestRoute, from: start)
            routeColor = .systemGreen
        }

        // 테스트용: Route[2] 사용
        if scoredRoutes.count > 2 {
            apply(route: scoredRoutes[2].0, from: start)
            routeColor = .systemGreen
        }
    }

    func apply(route: MKRoute, from start: CLLocationCoordinate2D) {
        self.route = route
        self.remainingDistance = route.distance
        self.region.center = start
        self.steps = route.steps.filter { !$0.instructions.isEmpty }
        self.currentStepIndex = 0
        self.currentInstruction = self.steps.first?.instructions ?? ""
    }

    func searchForLocation(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { response, error in
            guard let item = response?.mapItems.first else { return }
            self.destination = item.placemark.coordinate
            self.destinationName = item.name ?? "선택한 목적지"
            updateRoute(from: fixedStart)
        }
    }
}

// MARK: - Safety Evaluation

extension DirectionView {
    func safetyScore(for route: MKRoute) -> Int {
        var score = 0

        for step in route.steps {
            let points = step.polyline.points()
            let count = step.polyline.pointCount

            for i in stride(from: 0, to: count, by: 5) {
                let coord = points[i].coordinate
                let dangerCount = countNearbyDangerZones(coord, threshold: Constants.dangerThreshold)
                let policeCount = countNearbyPoliceStations(coord, threshold: Constants.policeThreshold)

                score += dangerCount * 100
                score -= policeCount * 20
            }
        }

        let distancePenalty = Int(route.distance / Constants.distancePenaltyUnit)
        return score + distancePenalty
    }

    func countNearbyDangerZones(_ coord: CLLocationCoordinate2D, threshold: Double) -> Int {
        let point = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        return MockData.dangerZones.filter {
            point.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)) < threshold
        }.count
    }

    func countNearbyPoliceStations(_ coord: CLLocationCoordinate2D, threshold: Double) -> Int {
        let point = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        return PoliceMockData.stations.filter {
            point.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)) < threshold
        }.count
    }
}

// MARK: - Preview

#Preview("DirectionView") {
    DirectionView()
}
