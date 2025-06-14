//
//  MockData.swift
//  iOS-Project
//
//  Created by han on 6/11/25.
//

import CoreLocation

struct MockData {
    static let dangerZones: [DangerZone] = [
        // 서울역/시청/무교동 일대
        DangerZone(title: "무교동", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5600, longitude: 126.9750)),
        DangerZone(title: "서울역 동편", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5540, longitude: 126.9725)),
        DangerZone(title: "숙대입구역 교차로", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5565, longitude: 126.9660)),
        DangerZone(title: "회현시장 일대", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5580, longitude: 126.9740)),
        DangerZone(title: "남대문 앞 사거리", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5515, longitude: 126.9680)),
        DangerZone(title: "숭례문 방면", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5485, longitude: 126.9800)),
        DangerZone(title: "남산예장자락", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5605, longitude: 126.9640)),
        DangerZone(title: "서울도서관 앞", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5667, longitude: 126.9774)),
        DangerZone(title: "서울시청 옆", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5661, longitude: 126.9783)),
        DangerZone(title: "시청 앞 인도", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5664, longitude: 126.9780)),
        DangerZone(title: "시청 근처1", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9782)),
        DangerZone(title: "시청 근처 1", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5663, longitude: 126.9779)),
        DangerZone(title: "시청 근처 2", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5670, longitude: 126.9785)),
        DangerZone(title: "세종대로20길 입구", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9792)),
        DangerZone(title: "황미집 앞", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5670, longitude: 126.9805)),

        // 을지로/명동/충무로 일대
        DangerZone(title: "을지로입구", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5669, longitude: 126.9830)),
        DangerZone(title: "을지로3가", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5663, longitude: 126.9910)),
        DangerZone(title: "명동역", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5633, longitude: 126.9820)),
        DangerZone(title: "충무로역", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5613, longitude: 126.9940)),
        DangerZone(title: "동대입구", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5599, longitude: 127.0050)),
        DangerZone(title: "동대문역사문화공원", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5657, longitude: 127.0070)),
        DangerZone(title: "청계천 오간수교", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5680, longitude: 126.9890)),
        DangerZone(title: "종로3가", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5705, longitude: 126.9910)),

        // 북쪽(혜화/성신여대)
        DangerZone(title: "혜화역 1번 출구", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5823, longitude: 127.0020)),
        DangerZone(title: "성신여대입구", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5925, longitude: 127.0160)),
        DangerZone(title: "신설동역", type: .sinkhole, coordinate: CLLocationCoordinate2D(latitude: 37.5747, longitude: 127.0250)),

        // 기타
        DangerZone(title: "대안길1", type: .fire, coordinate: CLLocationCoordinate2D(latitude: 37.5600, longitude: 126.9780)),
        DangerZone(title: "대안길2", type: .accident, coordinate: CLLocationCoordinate2D(latitude: 37.5645, longitude: 126.9840))
    ]
}

