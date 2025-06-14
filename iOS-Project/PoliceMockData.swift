//
//  PoliceMockData.swift
//  iOS-Project
//
//  Created by han on 6/13/25.
//

import Foundation
import CoreLocation

struct PoliceStation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct PoliceMockData {
    static let stations: [PoliceStation] = [
        // 한성대 인근
        PoliceStation(
            name: "성북경찰서 삼선지구대",
            coordinate: CLLocationCoordinate2D(latitude: 37.5898, longitude: 127.0071)
        ),
        PoliceStation(
            name: "혜화파출소",
            coordinate: CLLocationCoordinate2D(latitude: 37.5825, longitude: 127.0025)
        ),

        // 서울역 인근
        PoliceStation(
            name: "서울역파출소",
            coordinate: CLLocationCoordinate2D(latitude: 37.5542, longitude: 126.9710)
        ),
        PoliceStation(
            name: "남대문경찰서 서울역지구대",
            coordinate: CLLocationCoordinate2D(latitude: 37.5565, longitude: 126.9727)
        ),

        // 시청 인근
        PoliceStation(
            name: "중부경찰서 시청파출소",
            coordinate: CLLocationCoordinate2D(latitude: 37.5663, longitude: 126.9779)
        ),
        PoliceStation(
            name: "서울중부경찰서",
            coordinate: CLLocationCoordinate2D(latitude: 37.5657, longitude: 126.9896)
        )
    ]
}
