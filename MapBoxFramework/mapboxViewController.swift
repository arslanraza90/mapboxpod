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

open class MapBoxViewController: UIViewController, CLLocationManagerDelegate, NavigationViewControllerDelegate {
    
    var navigationMapView: NavigationMapView!
    private var placesClient: GMSPlacesClient!
    var manager:CLLocationManager!
    var places: [Place] = []
    var isFromOrigin = false
    var isFromDestination = false
    var origin: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    var backupOriginCordinates: CLLocationCoordinate2D?
    var isSpeedLimitShowimg = false
    
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
    
    lazy var originTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Current location",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        return textField
    }()
    
    lazy var originSubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var currentSpeedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 30.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3.0
        return view
    }()
    
    lazy var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10"
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var kilometerPerHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "km/h"
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        return label
    }()
    
    lazy var navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("Find Route", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    lazy var destinationMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var initialDestinationMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var destinationSubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var initialDestinationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
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
        imageView.image = convertUrlToImage(url: "https://i.ibb.co/FW0CQtF/Location-1.png")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var destinationTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Destination",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        return textField
    }()
    
    lazy var initialDestinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Destination"
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var searchMapsTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search Maps",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        return textField
    }()
    
    lazy var initialDestinationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 15.0
        tableView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
        return tableView
    }()
    
    lazy var mainTableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    
    lazy var routeMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var routesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Routes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = .black
        return label
    }()
    
    lazy var locationName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Travessa Francisco"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .black
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var fastestRoute: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fastest Route now"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.4235294118, green: 0.4235294118, blue: 0.4235294118, alpha: 0.9)
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var routeTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4m"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = .black
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var routeDistance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5km"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.9)
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var startButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 0.9)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var locationImage: UIImageView = {
        
        guard let filePath = Bundle(for: type(of: self)).path(forResource: "online-agreement", ofType: "png"),
              let image = UIImage(contentsOfFile: filePath),
              let data = image.pngData() else {
            fatalError("Image not available")
        }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image//convertUrlToImage(url: "https://i.ibb.co/T4zH7cv/loca.png")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var startLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    lazy var startButton: UIButton = {
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
        navigationMapView.userLocationStyle = .puck2D()
        navigationMapView.mapView.isUserInteractionEnabled = true
        initialDestinationButton.addTarget(self, action:#selector(self.initialDestinationButtonTapped), for: .touchUpInside)
        getUserLocation()
        let speedLimitView = SpeedLimitView()
        navigationMapView.addSubview(speedLimitView)
        initialSubViewSetup()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        addDoneButtonToKeyboard()
        
    }
    
    
    func addDoneButtonToKeyboard() {
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction(sender:)))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.originTextField.inputAccessoryView = toolbar
        self.destinationTextField.inputAccessoryView = toolbar
        self.searchMapsTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction(sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -300
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
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
        backupOriginCordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        if let lastLocation = locations.last {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil {
                    if let firstLocation = placemarks?[0],
                       let cityName = firstLocation.locality {
                        self?.findPlaces(query: cityName)
                    }
                }
            }
        }
        
    }
    
    func showCurrentRoute() {
        guard let currentRoute = routes?[currentRouteIndex] else { return }
        
        var routes = [currentRoute]
        routes.append(contentsOf: self.routes!.filter {
            $0 != currentRoute
        })
        navigationMapView.removeWaypoints()
        navigationMapView.show(routes)
        navigationMapView.showWaypoints(on: currentRoute)
    }
    
    func findPlaces(query: String) {
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                if places.isEmpty {
                    if let selectedPlaces = SharePreference.shared.getSelectedPlaces() {
                        self.places = selectedPlaces
                    }
                } else {
                    self.places = places
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCoordinatesFromPlaces(place: Place) {
        
        GooglePlacesManager.shared.resolveLocation(for: place) { result in
            switch result {
            case .success(let cordinate):
                if self.isFromOrigin {
                    self.origin = cordinate
                } else {
                    self.destination = cordinate
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func initialDestinationButtonTapped(sender: UIButton) {
        addSubViewsOnDestinationTap()
    }
    
    
    @objc func startNavigationAction(sender: UIButton) {
        
        if let destination = destination {
            if destination != backupOriginCordinates {
                navigationRouteTurnByTurn(origin: origin!, destination: destination)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Please select the destination other than your current location.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func findRouteAction(sender: UIButton) {
        manageSubViewOnFindRouteAction()
        
        if let destination  = destination {
            requestRoute(origin: origin!, destination: destination)
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
                
                
                
                
                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                simulating: .never)
                
                
                
                let topBanner = CustomTopBarViewController()
                let bottomBanner = CustomBottomBarViewController()
                let navigationOptions = NavigationOptions(styles: [CustomNightStyles()], navigationService: navigationService,
                                                          topBanner: topBanner,
                                                          bottomBanner: bottomBanner)
                let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                        navigationOptions: navigationOptions)
                bottomBanner.navigationViewController = navigationViewController
                
                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.showsSpeedLimits = true
                navigationViewController.navigationView.speedLimitView.regulatoryBorderColor = .white
                navigationViewController.navigationView.speedLimitView.signBackColor = .red
                navigationViewController.navigationView.speedLimitView.textColor = .white
                navigationViewController.delegate = self
                
                
                let stackView = navigationViewController.navigationView.floatingStackView
                let speedLimitView = navigationViewController.navigationView.speedLimitView
                speedLimitView.translatesAutoresizingMaskIntoConstraints = false
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                guard let navigationView = navigationViewController.navigationMapView else { return }
                guard let mapView = navigationView.mapView else { return }
                mapView.addSubview(strongSelf.currentSpeedView)
                strongSelf.currentSpeedView.addSubview(strongSelf.speedLabel)
                strongSelf.currentSpeedView.addSubview(strongSelf.speedLabel)
                strongSelf.currentSpeedView.addSubview(strongSelf.kilometerPerHour)
                strongSelf.isSpeedLimitShowimg = false
                
                
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: navigationViewController.navigationView.safeAreaLayoutGuide.topAnchor, constant: 120),
                    speedLimitView.topAnchor.constraint(equalTo: navigationViewController.navigationView.safeAreaLayoutGuide.bottomAnchor, constant: -160),
                    speedLimitView.trailingAnchor.constraint(equalTo: navigationViewController.navigationView.safeAreaLayoutGuide.trailingAnchor, constant: 328),
                    speedLimitView.heightAnchor.constraint(equalToConstant: 30),
                    speedLimitView.widthAnchor.constraint(equalToConstant: 30),
                    strongSelf.currentSpeedView.topAnchor.constraint(equalTo: navigationViewController.navigationView.safeAreaLayoutGuide.bottomAnchor, constant: -174),
                    strongSelf.currentSpeedView.trailingAnchor.constraint(equalTo: speedLimitView.leadingAnchor, constant: 353),
                    strongSelf.currentSpeedView.heightAnchor.constraint(equalToConstant: 60),
                    strongSelf.currentSpeedView.widthAnchor.constraint(equalToConstant: 60)
                    
                ])
                
                strongSelf.speedLabel.topAnchor.constraint(equalTo: strongSelf.currentSpeedView.topAnchor, constant: 12).isActive = true
                strongSelf.speedLabel.centerXAnchor.constraint(equalTo: strongSelf.currentSpeedView.centerXAnchor).isActive = true
                strongSelf.speedLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                strongSelf.speedLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
                
                strongSelf.kilometerPerHour.topAnchor.constraint(equalTo: strongSelf.speedLabel.bottomAnchor, constant: 4).isActive = true
                strongSelf.kilometerPerHour.centerXAnchor.constraint(equalTo: strongSelf.speedLabel.centerXAnchor).isActive = true
                
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
    func requestRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let navigationRouteOptions = NavigationRouteOptions(coordinates: [origin, destination])
        
        let cameraOptions = CameraOptions(center: origin, zoom: 7.0)
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
                
                let measurement = Measurement(value: currentRoute.distance, unit: UnitLength.meters).converted(to: .kilometers)
                let distanceInKilometers = Int(measurement.value)
                self.routeDistance.text = "\(distanceInKilometers) km"
                
                
                let expectedTime = self.secondsToHoursMinutesSeconds(Int(currentRoute.expectedTravelTime))
                
                if expectedTime.0 != 0{
                    self.routeTime.text = "\(expectedTime.0) h" + " " + "\(expectedTime.1) m"
                } else {
                    self.routeTime.text = "\(expectedTime.1) m"
                }
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    public func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    public func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        
        let speedInKilometers = location.speed * 3.6
        
        if let speedLimit = navigationViewController.navigationView.speedLimitView.speedLimit?.value  {
            if speedInKilometers > speedLimit {
                kilometerPerHour.textColor = .red
                speedLabel.textColor = .red
                if isSpeedLimitShowimg == false {
                    navigationViewController.showsSpeedLimits = true
                    isSpeedLimitShowimg = true
                }
            } else {
                kilometerPerHour.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
                speedLabel.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
                navigationViewController.showsSpeedLimits = false
                isSpeedLimitShowimg = false
            }
        }
        
        let currentSpeed = String(format: "%.0f", speedInKilometers)
        speedLabel.text = currentSpeed
    }
}

extension MapBoxViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromOrigin || isFromDestination {
            return places.count + 1
        }
        return places.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for:indexPath) as! LocationTableViewCell
        
        if isFromOrigin || isFromDestination {
            if indexPath.row == 0 {
                cell.placeName.text = "Current Location"
            } else {
                cell.placeName.text = places[indexPath.row - 1].name
            }
        } else {
            cell.placeName.text = places[indexPath.row].name
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        var place: Place
        if indexPath.row == 0 {
            if isFromOrigin {
                origin = backupOriginCordinates
                originTextField.text = "Current location"
            } else if isFromDestination {
                destination = backupOriginCordinates
                destinationTextField.text = "Current location"
                locationName.text = "Current location"
            } else  {
                place = places[indexPath.row]
                destinationTextField.text = place.name
                locationName.text = place.name
                getCoordinatesFromPlaces(place: place)
            }
        }
        
        if indexPath.row > 0 {
            
            if isFromOrigin || isFromDestination {
                place = places[indexPath.row - 1]
                if isFromOrigin {
                    originTextField.text = place.name
                } else {
                    destinationTextField.text = place.name
                    locationName.text = place.name
                }
            } else {
                place = places[indexPath.row]
                destinationTextField.text = place.name
                locationName.text = place.name
            }
            getCoordinatesFromPlaces(place: place)
            
            
            if let selectedPlaces = SharePreference.shared.getSelectedPlaces() {
                if !(selectedPlaces.contains(where: {$0.identifier == place.identifier})) {
                    var list = [Place]()
                    list = selectedPlaces
                    if list.count > 5 {
                        list.remove(at: 0)
                    }
                    list.append(place)
                    SharePreference.shared.setSelectedPlaces(list)
                }
            } else {
                SharePreference.shared.setSelectedPlaces([place])
            }
        }
        addSubviewsOnCellSelection()
    }
}


extension MapBoxViewController: UITextFieldDelegate{
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(string == ""){
            if textField == searchMapsTextField {
                findPlaces(query: textField.text!)
            } else if textField == destinationTextField {
                findPlaces(query: textField.text!)
            } else if textField == originTextField {
                findPlaces(query: textField.text!)
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == originTextField {
            originSubView.layer.masksToBounds = true
            originSubView.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.4745098039, blue: 1, alpha: 0.9)
            originSubView.layer.borderWidth = 1.0
            originTextField.text = ""
            isFromOrigin = true
            isFromDestination = false
            tableView.reloadData()
            if self.navigationButton.isDescendant(of: navigationMapView) {
                navigationButton.removeFromSuperview()
                manageSubViewsOnTextFieldEditing()
            } else {
                routeMainView.removeFromSuperview()
                manageSubViewsOnTextFieldEditing()
            }
            
        } else if textField == destinationTextField {
            destinationSubView.layer.masksToBounds = true
            destinationSubView.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.4745098039, blue: 1, alpha: 0.9)
            destinationSubView.layer.borderWidth = 1.0
            destinationTextField.text = ""
            isFromOrigin = false
            isFromDestination = true
            tableView.reloadData()
            if self.navigationButton.isDescendant(of: navigationMapView) {
                navigationButton.removeFromSuperview()
                manageSubViewsOnTextFieldEditing()
            } else {
                routeMainView.removeFromSuperview()
                manageSubViewsOnTextFieldEditing()
            }
        }
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == originTextField {
            originSubView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else if textField == destinationTextField {
            destinationSubView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return true
    }
}


func convertUrlToImage(url: String) -> UIImage{
    let url = URL(string: url)
    var imageView = UIImage()
    DispatchQueue.main.async {
        guard let imageData = try? Data(contentsOf: url!) else { return }
        guard let image = UIImage(data: imageData) else { return }
        imageView = image
    }
    return imageView
}


class CustomTopBarViewController: ContainerViewController {
    private lazy var instructionsBannerTopOffsetConstraint = {
        return instructionsBannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    }()
    private lazy var centerOffset: CGFloat = calculateCenterOffset(with: view.bounds.size)
    private lazy var instructionsBannerCenterOffsetConstraint = {
        return instructionsBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
    }()
    private lazy var instructionsBannerWidthConstraint = {
        return instructionsBannerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
    }()
    
    // You can Include one of the existing Views to display route-specific info
    lazy var instructionsBannerView: InstructionsBannerView = {
        let banner = InstructionsBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        banner.layer.cornerRadius = 25
        banner.separatorView.isHidden = true
        return banner
    }()
    
    override func viewDidLoad() {
        view.addSubview(instructionsBannerView)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateConstraints()
    }
    
    private func setupConstraints() {
        instructionsBannerCenterOffsetConstraint.isActive = true
        instructionsBannerTopOffsetConstraint.isActive = true
        instructionsBannerWidthConstraint.isActive = true
    }
    
    private func updateConstraints() {
        instructionsBannerCenterOffsetConstraint.constant = centerOffset
    }
    
    // MARK: - Device rotation
    
    private func calculateCenterOffset(with size: CGSize) -> CGFloat {
        return (size.height < size.width ? -size.width / 5 : 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        centerOffset = calculateCenterOffset(with: size)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
    
    // MARK: - NavigationServiceDelegate implementation
    
    public func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        // pass updated data to sub-views which also implement `NavigationServiceDelegate`
        instructionsBannerView.updateDistance(for: progress.currentLegProgress.currentStepProgress)
    }
    
    public func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
        instructionsBannerView.update(for: instruction)
    }
    
    public func navigationService(_ service: NavigationService, didRerouteAlong route: Route, at location: CLLocation?, proactive: Bool) {
        instructionsBannerView.updateDistance(for: service.routeProgress.currentLegProgress.currentStepProgress)
    }
}

class CustomBottomBarViewController: ContainerViewController, CustomBottomBannerViewDelegate {
    
    weak var navigationViewController: NavigationViewController?
    
    // Or you can implement your own UI elements
    lazy var bannerView: CustomBottomBannerView = {
        let banner = CustomBottomBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.delegate = self
        return banner
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(bannerView)
        
        let safeArea = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            bannerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            bannerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            bannerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    private func setupConstraints() {
        if let superview = view.superview?.superview {
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - NavigationServiceDelegate implementation
    
    func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        // Update your controls manually
        //        bannerView.progress = Float(progress.fractionTraveled)
        
        let durationRemaining = self.secondsToHoursMinutesSeconds(Int(progress.durationRemaining))
        let expectedTime = self.secondsToHoursMinutesSeconds(Int(progress.route.expectedTravelTime))
        
        if durationRemaining.0 != 0{
            bannerView.eta = "\(durationRemaining.0)" + ":" + "\(durationRemaining.1)"
            bannerView.timeTotal = "\(expectedTime.0)" + ":" + "\(expectedTime.1)"
        } else {
            bannerView.eta = "\(durationRemaining.1)" + ":" + "\(durationRemaining.2)"
            bannerView.timeTotal = "\(expectedTime.1)"
        }
        
        
        
        let measurement = Measurement(value: progress.route.distance, unit: UnitLength.meters).converted(to: .kilometers)
        let distanceInKilometers = Int(measurement.value)
        bannerView.distanceTotal = String(distanceInKilometers)
    }
    
    // MARK: - CustomBottomBannerViewDelegate implementation
    
    func customBottomBannerDidCancel(_ banner: CustomBottomBannerView) {
        navigationViewController?.dismiss(animated: true,
                                          completion: nil)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}


