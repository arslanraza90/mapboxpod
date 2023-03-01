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
    var places: [Place] = []
    var isFromOrigin = false
    
    var origin: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    var backupOriginCordinates: CLLocationCoordinate2D?
    
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
    
    lazy var navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8637991548, green: 0.4307671189, blue: 1, alpha: 1)
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
        imageView.image = UIImage(named: "locationIconPur")
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
        view.backgroundColor = #colorLiteral(red: 0.5529411765, green: 0.6980392157, blue: 0.9803921569, alpha: 0.9)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var locationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "locationIcon")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var startLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = .white
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
        initialSubViewSetup()
        let speedLimitView = SpeedLimitView()
        navigationMapView.addSubview(speedLimitView)
        
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
        navigationMapView.show(routes)
        navigationMapView.showWaypoints(on: currentRoute)
    }
    
    func findPlaces(query: String) {
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                self.places = places
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
            navigationRouteTurnByTurn(origin: origin!, destination: destination)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select the destination", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                
                let navigationOptions = NavigationOptions(styles: [CustomNightStyles()],
                                                          navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                        navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.showsSpeedLimits = true
                
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
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    public func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        dismiss(animated: true, completion: nil)
    }
}

extension MapBoxViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromOrigin {
            return places.count + 1
        } else {
            return places.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for:indexPath) as! LocationTableViewCell
        if isFromOrigin {
            if indexPath.row == 0 {
                cell.placeName.text = "Current Location"
            }
            if indexPath.row > 0 {
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
        if isFromOrigin {
            if indexPath.row == 0 {
                origin = backupOriginCordinates
                originTextField.text = "Current location"
            }
            
            if indexPath.row > 0 {
                let place = places[indexPath.row - 1]
                
                if isFromOrigin {
                    originTextField.text = place.name
                } else {
                    destinationTextField.text = place.name
                    locationName.text = place.name
                }
                getCoordinatesFromPlaces(place: place)
            }
            
        } else {
            let place = places[indexPath.row]
            
            if isFromOrigin {
                originTextField.text = place.name
            } else {
                destinationTextField.text = place.name
                locationName.text = place.name
            }
            
            getCoordinatesFromPlaces(place: place)
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

