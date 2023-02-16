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

 
public class MapBoxViewController: UIViewController {
    
    var navigationMapView: NavigationMapView!
    private var placesClient: GMSPlacesClient!
    
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
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var testFiledSuperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var testFiledSuperView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
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

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSPlacesClient.provideAPIKey("AIzaSyAMlml7aqa1BQRUnmmmgixmFoDR3mdpRUI")
        placesClient = GMSPlacesClient.shared()
        navigationMapView = NavigationMapView(frame: view.bounds)
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationMapView.delegate = self
        navigationMapView.userLocationStyle = .puck2D()
        
        
        view.addSubview(navigationMapView)
        navigationMapView.addSubview(navigationButton)
        navigationMapView.addSubview(testFiledSuperView)
        navigationMapView.addSubview(testFiledSuperView1)
        testFiledSuperView.addSubview(originLabel)
        testFiledSuperView1.addSubview(destinationLabel)
        navigationButton.addTarget(self, action:#selector(self.tappedButton), for: .touchUpInside)

        layoutSubviews()
        setupLabelTap()
        
    }
    
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            navigationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            navigationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            navigationButton.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -50),
            navigationButton.heightAnchor.constraint(equalToConstant: 50),
            
            testFiledSuperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testFiledSuperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testFiledSuperView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            testFiledSuperView.heightAnchor.constraint(equalToConstant: 50),
            
            originLabel.leadingAnchor.constraint(equalTo: testFiledSuperView.leadingAnchor, constant: 0),
            originLabel.trailingAnchor.constraint(equalTo: testFiledSuperView.trailingAnchor, constant: 0),
            originLabel.bottomAnchor.constraint(equalTo: testFiledSuperView.bottomAnchor, constant: 0),
            originLabel.heightAnchor.constraint(equalToConstant: 50),
            
            testFiledSuperView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testFiledSuperView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testFiledSuperView1.bottomAnchor.constraint(equalTo: testFiledSuperView.bottomAnchor, constant: 70),
            testFiledSuperView1.heightAnchor.constraint(equalToConstant: 50),
            
            destinationLabel.leadingAnchor.constraint(equalTo: testFiledSuperView1.leadingAnchor, constant: 0),
            destinationLabel.trailingAnchor.constraint(equalTo: testFiledSuperView1.trailingAnchor, constant: 0),
            destinationLabel.bottomAnchor.constraint(equalTo: testFiledSuperView1.bottomAnchor, constant: 0),
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
        
        let origin = UITapGestureRecognizer(target: self, action: #selector(self.originLabelTapped(_:)))
        self.originLabel.isUserInteractionEnabled = true
        self.originLabel.addGestureRecognizer(origin)
        
        let destination = UITapGestureRecognizer(target: self, action: #selector(self.destinationLabelTapped(_:)))
        self.destinationLabel.isUserInteractionEnabled = true
        self.destinationLabel.addGestureRecognizer(destination)
        
    }
    
    @objc func originLabelTapped(_ sender: UITapGestureRecognizer) {
        
        isOrigin = true
        
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
        navigationRouteTurnByTurn(origin: origin!, destination: destination!)
//        streetViewRoute(origin: origin!, destination: destination!)
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
                
//                guard let route = response.routes?.first else { return }
//                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
//
//                let navigationViewController = NavigationViewController(for: indexedRouteResponse)

//                 For demonstration purposes, simulate locations if the Simulate Navigation option is on.
//                 Since first route is retrieved from response `routeIndex` is set to 0.
                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                simulating: .always)


                let navigationOptions = NavigationOptions(styles: [CustomNightStyles()],
                                                          navigationService: navigationService)
//                let navigationOptions = NavigationOptions(navigationService: navigationService)
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
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
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
        
        if isOrigin {
            origin = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
            print(origin)
            originLabel.text = place.name
        }else {
            destination = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
            destinationLabel.text = place.name
            print(destination)
        }

        if origin?.longitude != nil && destination?.latitude != nil {
            requestRoute(origin: origin!, destination: destination!)
        }
        
        
        
        print("Place name: \(String(describing: place.name))")
        print("Place cordinates: \(place.coordinate)")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
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


class CustomNightStyles: NightStyle {

    required init() {
        super.init()

        styleType = .night
    }

    override func apply() {
        super.apply()

        // `BottomBannerView` is not used on CarPlay, so styling is only provided for iPhone and iPad.
        BottomBannerView.appearance(for: UITraitCollection(userInterfaceIdiom: .phone)).backgroundColor = .black
        BottomBannerView.appearance(for: UITraitCollection(userInterfaceIdiom: .pad)).backgroundColor = .darkGray
    }
}

