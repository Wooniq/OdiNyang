//
//  Utils.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import Foundation

func iconForType(_ type: DangerZoneType) -> String {
    switch type {
    case .fire: return "fire"
    case .accident: return "car"
    case .sinkhole: return "hole"
    }
}
