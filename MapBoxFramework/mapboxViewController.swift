//
//  MapBoxViewController.swift
//  MapBox
//
//  Created by Arslan Raza on 09/02/2023.
//

import MapboxMaps
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import GooglePlaces
import CoreLocation

 
open class MapBoxViewController: UIViewController, CLLocationManagerDelegate {
    
    var navigationMapView: NavigationMapView!
    private var placesClient: GMSPlacesClient!
    var manager:CLLocationManager!
    
    var origin: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    
    var isOrigin = false
    
    var currentRouteIndex = 0 {
        didSet {
            showCurrentRoute()
        }
    }
    
    var routes: [Route]? {
        return routeResponse?.routes
    }
    
    var routeResponse: RouteResponse? {
        didSet {
            guard routes != nil else {
                navigationMapView.removeRoutes()
                return
            }
            currentRouteIndex = 0
        }
    }
    
    
    lazy var originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Your location"
        label.textColor = .white
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var textFiledSuperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var textFiledSuperView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Start Navigation", for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
   public func configrations() {
       
       let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/arslanraza900/clecn7cwl001k01piwth96e2d"))
       let mapView = MapView(frame: view.bounds, mapInitOptions: options)
       
       GMSPlacesClient.provideAPIKey("AIzaSyAMlml7aqa1BQRUnmmmgixmFoDR3mdpRUI")
       placesClient = GMSPlacesClient.shared()
       navigationMapView = NavigationMapView(frame: view.bounds, mapView: mapView)
       navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       navigationMapView.delegate = self
       navigationMapView.userLocationStyle = .puck2D()
       let speedLimitView = SpeedLimitView()
       let speed = speedLimitView.currentSpeed
       // Add it as a subview
       view.addSubview(navigationMapView)
       navigationMapView.addSubview(originLabel)
       navigationMapView.addSubview(speedLimitView)
       navigationMapView.addSubview(navigationButton)
       navigationMapView.addSubview(textFiledSuperView)
       navigationMapView.addSubview(textFiledSuperView1)
       textFiledSuperView.addSubview(originLabel)
       textFiledSuperView1.addSubview(destinationLabel)
       navigationMapView.mapView.isUserInteractionEnabled = true
       navigationButton.addTarget(self, action:#selector(self.tappedButton), for: .touchUpInside)
       getUserLocation()
       layoutSubviews()
       setupLabelTap()
    }
    
    func getUserLocation(){
        self.manager = CLLocationManager()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         self.manager.stopUpdatingLocation() //stop getting user location
    
        let location = locations[0]
        let userSpeed = location.speed
        
//        originLabel.text = String(describing: userSpeed)
        
        origin = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
         //self.userLocation = locations[0] as! CLLocation
     }
    
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            navigationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            navigationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            navigationButton.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -50),
            navigationButton.heightAnchor.constraint(equalToConstant: 50),
            
            textFiledSuperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textFiledSuperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textFiledSuperView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textFiledSuperView.heightAnchor.constraint(equalToConstant: 50),
            
            originLabel.leadingAnchor.constraint(equalTo: textFiledSuperView.leadingAnchor, constant: 10),
            originLabel.trailingAnchor.constraint(equalTo: textFiledSuperView.trailingAnchor, constant: 0),
            originLabel.bottomAnchor.constraint(equalTo: textFiledSuperView.bottomAnchor, constant: 0),
            originLabel.heightAnchor.constraint(equalToConstant: 50),
            
            textFiledSuperView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textFiledSuperView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textFiledSuperView1.bottomAnchor.constraint(equalTo: textFiledSuperView.bottomAnchor, constant: 70),
            textFiledSuperView1.heightAnchor.constraint(equalToConstant: 50),
            
            destinationLabel.leadingAnchor.constraint(equalTo: textFiledSuperView1.leadingAnchor, constant: 10),
            destinationLabel.trailingAnchor.constraint(equalTo: textFiledSuperView1.trailingAnchor, constant: 0),
            destinationLabel.bottomAnchor.constraint(equalTo: textFiledSuperView1.bottomAnchor, constant: 0),
            destinationLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func showCurrentRoute() {
        guard let currentRoute = routes?[currentRouteIndex] else { return }
        
        var routes = [currentRoute]
        routes.append(contentsOf: self.routes!.filter {
            $0 != currentRoute
        })
        navigationMapView.show(routes)
        navigationMapView.showWaypoints(on: currentRoute)
    }
    
    func setupLabelTap() {
        
//        let origin = UITapGestureRecognizer(target: self, action: #selector(self.originLabelTapped(_:)))
//        self.originLabel.isUserInteractionEnabled = true
//        self.originLabel.addGestureRecognizer(origin)
        
        let destination = UITapGestureRecognizer(target: self, action: #selector(self.destinationLabelTapped(_:)))
        self.destinationLabel.isUserInteractionEnabled = true
        self.destinationLabel.addGestureRecognizer(destination)
        
    }
    
//    @objc func originLabelTapped(_ sender: UITapGestureRecognizer) {
//
//        isOrigin = true
//
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
//                                                  UInt(GMSPlaceField.name.rawValue))
//        autocompleteController.placeFields = fields
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        //      filter.types = .address
//        autocompleteController.autocompleteFilter = filter
//        present(autocompleteController, animated: true, completion: nil)
//        }
    
    func showSearchViewController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue))
        autocompleteController.placeFields = fields
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
//        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    @objc func destinationLabelTapped(_ sender: UITapGestureRecognizer) {
        
        isOrigin = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
                                                  UInt(GMSPlaceField.name.rawValue))
        autocompleteController.placeFields = fields
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        //      filter.types = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        }

    
    @objc func tappedButton(sender: UIButton) {
        if let destination = destination {
            navigationRouteTurnByTurn(origin: origin!, destination: destination)
//            streetViewRoute(origin: origin!, destination: destination)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select the destination", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func navigationRouteTurnByTurn(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let options = NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(options) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                
                //                 For demonstration purposes, simulate locations if the Simulate Navigation option is on.
                //                 Since first route is retrieved from response `routeIndex` is set to 0.
                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                simulating: .always)
                
                
                let navigationOptions = NavigationOptions(styles: [CustomNightStyles()],
                                                          navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                        navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.showsSpeedLimits = true
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    func streetViewRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let routeOptions = NavigationRouteOptions(coordinates: [origin, destination])
        
        Directions.shared.calculate(routeOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                
                // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                simulating: .always)
                let navigationOptions = NavigationOptions(styles: [CustomDayStyle(), CustomNightStyle()],
                                                          navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                        navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                navigationViewController.routeLineTracksTraversal = true
                
                strongSelf.present(navigationViewController, animated: true, completion: {
                    
                    let customButton = UIButton()
                    customButton.setTitle("Press", for: .normal)
                    customButton.translatesAutoresizingMaskIntoConstraints = false
                    customButton.backgroundColor = .blue
                    customButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
                    self?.navigationMapView.mapView.addSubview(customButton)
                    customButton.bottomAnchor.constraint(equalTo: self!.navigationMapView.mapView.bottomAnchor, constant: 0).isActive = true
                    customButton.leftAnchor.constraint(equalTo: self!.navigationMapView.mapView.leftAnchor, constant: 0).isActive = true
                    customButton.rightAnchor.constraint(equalTo: self!.navigationMapView.mapView.rightAnchor, constant: 0).isActive = true

                    self!.navigationMapView.mapView.setNeedsLayout()
                    
                    
                })
            }
        }
    }
    
    func requestRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let navigationRouteOptions = NavigationRouteOptions(coordinates: [origin, destination])
        
        let cameraOptions = CameraOptions(center: origin, zoom: 13.0)
        self.navigationMapView.mapView.mapboxMap.setCamera(to: cameraOptions)
        
        Directions.shared.calculate(navigationRouteOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let routes = response.routes,
                      let currentRoute = routes.first,
                      let self = self else { return }
                
                self.routeResponse = response
                self.navigationMapView.show(routes)
                self.navigationMapView.showWaypoints(on: currentRoute)
            }
        }
    }
    
    public func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Styling methods
    func customCircleLayer(with identifier: String, sourceIdentifier: String) -> CircleLayer {
        var circleLayer = CircleLayer(id: identifier)
        circleLayer.source = sourceIdentifier
        let opacity = Exp(.switchCase) {
            Exp(.any) {
                Exp(.get) {
                    "waypointCompleted"
                }
            }
            0.5
            1
        }
        circleLayer.circleColor = .constant(.init(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
        circleLayer.circleOpacity = .expression(opacity)
        circleLayer.circleRadius = .constant(.init(10))
        circleLayer.circleStrokeColor = .constant(.init(UIColor.black))
        circleLayer.circleStrokeWidth = .constant(.init(1))
        circleLayer.circleStrokeOpacity = .expression(opacity)
        return circleLayer
    }
    
    func customSymbolLayer(with identifier: String, sourceIdentifier: String) -> SymbolLayer {
        var symbolLayer = SymbolLayer(id: identifier)
        symbolLayer.source = sourceIdentifier
        symbolLayer.textField = .expression(Exp(.toString) {
            Exp(.get) {
                "name"
            }
        })
        symbolLayer.textSize = .constant(.init(10))
        symbolLayer.textOpacity = .expression(Exp(.switchCase) {
            Exp(.any) {
                Exp(.get) {
                    "waypointCompleted"
                }
            }
            0.5
            1
        })
        symbolLayer.textHaloWidth = .constant(.init(0.25))
        symbolLayer.textHaloColor = .constant(.init(UIColor.black))
        return symbolLayer
    }
    
    func customWaypointShape(shapeFor waypoints: [Waypoint], legIndex: Int) -> FeatureCollection {
        var features = [Turf.Feature]()
        for (waypointIndex, waypoint) in waypoints.enumerated() {
            var feature = Feature(geometry: .point(Point(waypoint.coordinate)))
            feature.properties = [
                "waypointCompleted": .boolean(waypointIndex < legIndex),
                "name": .number(Double(waypointIndex + 1))
            ]
            features.append(feature)
        }
        return FeatureCollection(features: features)
    }
}
 
// MARK: Delegate methods
extension MapBoxViewController: NavigationMapViewDelegate {
    
    public func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        print(location)
    }
    
    public func navigationMapView(_ navigationMapView: NavigationMapView, waypointCircleLayerWithIdentifier identifier: String, sourceIdentifier: String) -> CircleLayer? {
        return customCircleLayer(with: identifier, sourceIdentifier: sourceIdentifier)
    }
    
    public func navigationMapView(_ navigationMapView: NavigationMapView, waypointSymbolLayerWithIdentifier identifier: String, sourceIdentifier: String) -> SymbolLayer? {
        return customSymbolLayer(with: identifier, sourceIdentifier: sourceIdentifier)
    }
    
    public func navigationMapView(_ navigationMapView: NavigationMapView, shapeFor waypoints: [Waypoint], legIndex: Int) -> FeatureCollection? {
        return customWaypointShape(shapeFor: waypoints, legIndex: legIndex)
    }
}
 
extension MapBoxViewController: NavigationViewControllerDelegate {
    public func navigationViewController(_ navigationViewController: NavigationViewController, waypointCircleLayerWithIdentifier identifier: String, sourceIdentifier: String) -> CircleLayer? {
        return customCircleLayer(with: identifier, sourceIdentifier: sourceIdentifier)
    }
    
    public func navigationViewController(_ navigationViewController: NavigationViewController, waypointSymbolLayerWithIdentifier identifier: String, sourceIdentifier: String) -> SymbolLayer? {
        return customSymbolLayer(with: identifier, sourceIdentifier: sourceIdentifier)
    }
    
    public func navigationViewController(_ navigationViewController: NavigationViewController, shapeFor waypoints: [Waypoint], legIndex: Int) -> FeatureCollection? {
        return customWaypointShape(shapeFor: waypoints, legIndex: legIndex)
    }
}




extension MapBoxViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        destination = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        destinationLabel.text = place.name
        if let destination = destination{
            requestRoute(origin: origin!, destination: destination)
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    public func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

