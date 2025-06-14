//
//  MapView.swift
//  iOS-Project
//
//  Created by han on 6/12/25.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var route: MKRoute?
    @Binding var region: MKCoordinateRegion
    var destination: CLLocationCoordinate2D
    var startLocation: CLLocationCoordinate2D?
    @Binding var routeColor: UIColor
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)

        // 출발지 중심으로 확대
        let zoomRegion = MKCoordinateRegion(
            center: startLocation ?? region.center,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        uiView.setRegion(zoomRegion, animated: true)
            
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)
        
        // 경로 라인
        if let route = route {
            DispatchQueue.main.async {
                uiView.delegate = context.coordinator
                uiView.addOverlay(route.polyline, level: .aboveRoads)
            }
        }
        
        // 출발지 마커
        let startCoord = route?.steps.first?.polyline.coordinate ?? startLocation ?? region.center
        let start = MKPointAnnotation()
        start.coordinate = startCoord
        start.title = "출발지"
        uiView.addAnnotation(start)
        
        // 도착지 마커
        let end = MKPointAnnotation()
        end.coordinate = destination
        end.title = "도착지"
        uiView.addAnnotation(end)
        
        // 파출소 마커
        for station in PoliceMockData.stations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = station.coordinate
            annotation.title = station.name
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(routeColor: $routeColor)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var routeColor: UIColor
        
        init(routeColor: Binding<UIColor>) {
            _routeColor = routeColor
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = routeColor
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            let identifier = "marker"
            
            // 파출소 마커
            if let title = annotation.title ?? "", title.contains("파출소") || title.contains("지구대") || title.contains("경찰서"){
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: "police") as? MKAnnotationView
                if view == nil {
                    view = MKAnnotationView(annotation: annotation, reuseIdentifier: "police")
                    view?.canShowCallout = true
                    
                    if let image = UIImage(named: "police") {
                        let size = CGSize(width: 40, height: 43)
                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                        image.draw(in: CGRect(origin: .zero, size: size))
                        view?.image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                    }
                } else {
                    view?.annotation = annotation
                }
                return view
            }
            
            // 출발지 마커
            if let title = annotation.title ?? "", title == "출발지" {
                let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                marker.markerTintColor = .systemGreen
                marker.canShowCallout = true
                return marker
            }
            
            // 도착지 마커
            if let title = annotation.title ?? "", title == "도착지" {
                let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                marker.markerTintColor = .systemRed
                marker.canShowCallout = true
                return marker
            }
            
            return nil
        }
    }
}
