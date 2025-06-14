//
//  DangerZone.swift
//  iOS-Project
//
//  Created by han on 6/2/25.
//

import CoreLocation

enum DangerZoneType: String {
    case fire
    case accident
    case sinkhole
    
    var description: String {
            switch self {
            case .fire: return "화재"
            case .accident: return "교통사고"
            case .sinkhole: return "싱크홀"
            }
        }
}

struct DangerZone: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let type: DangerZoneType
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: DangerZone, rhs: DangerZone) -> Bool {
        return lhs.id == rhs.id
    }
}

struct DangerZoneDistance: Identifiable {
    let id = UUID()
    let zone: DangerZone
    let distance: CLLocationDistance
}
