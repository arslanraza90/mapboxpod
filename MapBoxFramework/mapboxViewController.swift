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
        label.textColor = .darkGray
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
    
    lazy var originSubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "destination-view-background")
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
        button.backgroundColor = UIColor(named: "routeButtonColor")
        button.setTitle("Find Route", for: .normal)
        button.layer.cornerRadius = 12.0
        return button
    }()
    
    lazy var destinationMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var destinationSubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "destination-view-background")
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var serachImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(systemName: "magnifyingglass")
         imageView.tintColor = .darkGray
         return imageView
     }()
    
    lazy var serachImageViewOrigin: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(systemName: "magnifyingglass")
         imageView.tintColor = .darkGray
         return imageView
     }()
    
    
    lazy var locationIcon: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(named: "location")
        imageView.contentMode = .scaleToFill
         return imageView
     }()
    
    lazy var destinationViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Destination"
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var destinationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
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
       navigationMapView.mapView.isUserInteractionEnabled = true
       navigationButton.addTarget(self, action:#selector(self.tappedButton), for: .touchUpInside)
       destinationButton.addTarget(self, action:#selector(self.destinationButtonTapped), for: .touchUpInside)
       addSubviews()
       
       getUserLocation()
       layoutSubviews()

    }
    
    func addSubviews() {
        
        let speedLimitView = SpeedLimitView()
        view.addSubview(navigationMapView)
        navigationMapView.addSubview(originLabel)
        navigationMapView.addSubview(speedLimitView)
        navigationMapView.addSubview(navigationButton)
        navigationMapView.addSubview(destinationMainView)
        destinationMainView.addSubview(destinationSubView)
        destinationMainView.addSubview(locationIcon)
        destinationSubView.addSubview(destinationViewLabel)
        destinationSubView.addSubview(destinationButton)
        destinationMainView.addSubview(originSubView)
        originSubView.addSubview(originLabel)
        
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
        
        origin = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
     }
    
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            
            
            
            navigationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            navigationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            navigationButton.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -30),
            navigationButton.heightAnchor.constraint(equalToConstant: 48),
            
            destinationMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            destinationMainView.bottomAnchor.constraint(equalTo: navigationButton.topAnchor, constant: -15),
            destinationMainView.heightAnchor.constraint(equalToConstant: 140),
            
            originSubView.leadingAnchor.constraint(equalTo: destinationMainView.leadingAnchor, constant: 40),
            originSubView.trailingAnchor.constraint(equalTo: destinationMainView.trailingAnchor, constant: -12),
            originSubView.bottomAnchor.constraint(equalTo: destinationSubView.topAnchor, constant: -12),
            originSubView.topAnchor.constraint(equalTo: destinationMainView.topAnchor, constant: 14),
            
            destinationSubView.leadingAnchor.constraint(equalTo: destinationMainView.leadingAnchor, constant: 40),
            destinationSubView.trailingAnchor.constraint(equalTo: destinationMainView.trailingAnchor, constant: -12),
            destinationSubView.bottomAnchor.constraint(equalTo: destinationMainView.bottomAnchor, constant: -14),
            destinationSubView.topAnchor.constraint(equalTo: originSubView.bottomAnchor, constant: 0),
            destinationSubView.heightAnchor.constraint(equalTo: originSubView.heightAnchor),
            
            destinationViewLabel.leadingAnchor.constraint(equalTo: destinationSubView.leadingAnchor, constant: 12),
            destinationViewLabel.centerYAnchor.constraint(equalTo: destinationSubView.centerYAnchor),
            destinationViewLabel.heightAnchor.constraint(equalToConstant: 20),
            destinationViewLabel.widthAnchor.constraint(equalToConstant: 120),
            
            destinationButton.centerXAnchor.constraint(equalTo: destinationSubView.centerXAnchor),
            destinationButton.centerYAnchor.constraint(equalTo: destinationSubView.centerYAnchor),
            destinationButton.heightAnchor.constraint(equalTo: destinationSubView.heightAnchor),
            destinationButton.widthAnchor.constraint(equalTo: destinationSubView.widthAnchor),
            
            originLabel.leadingAnchor.constraint(equalTo: originSubView.leadingAnchor, constant: 12),
            originLabel.centerYAnchor.constraint(equalTo: originSubView.centerYAnchor),
            originLabel.heightAnchor.constraint(equalToConstant: 20),
            originLabel.widthAnchor.constraint(equalToConstant: 120),
            
            locationIcon.leadingAnchor.constraint(equalTo: destinationMainView.leadingAnchor, constant: 10),
            locationIcon.bottomAnchor.constraint(equalTo: destinationMainView.bottomAnchor, constant: -17),
            locationIcon.topAnchor.constraint(equalTo: destinationMainView.topAnchor, constant: 20),
            locationIcon.widthAnchor.constraint(equalToConstant: 25),
            
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
        
        let destination = UITapGestureRecognizer(target: self, action: #selector(self.destinationLabelTapped(_:)))
        self.destinationLabel.isUserInteractionEnabled = true
        self.destinationLabel.addGestureRecognizer(destination)
        
    }
    
    func showSearchViewController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue))
        autocompleteController.placeFields = fields
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    @objc func destinationLabelTapped(_ sender: UITapGestureRecognizer) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
                                                  UInt(GMSPlaceField.name.rawValue))
        autocompleteController.placeFields = fields
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        }
    
    @objc func destinationButtonTapped(sender: UIButton) {
        
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
                                                                simulating: .never)
                
                
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
                                                                simulating: .never)
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
        destinationViewLabel.text = place.name
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


