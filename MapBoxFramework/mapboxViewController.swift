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

open class MapBoxViewController: UIViewController, CLLocationManagerDelegate, NavigationViewControllerDelegate, UIViewControllerTransitioningDelegate, NavigationMapViewDelegate {

    var navigationMapView: NavigationMapView!
    private var placesClient: GMSPlacesClient!
    var manager:CLLocationManager!
    var places: [Place] = []
    var isFromOrigin = false
    var isFromDestination = false
    var origin: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    var backupOriginCordinates: CLLocationCoordinate2D? {
        didSet {
            setCurrentLocation()
        }
    }
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
    
    lazy var speedLimitOuterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 18.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3.0
        view.isHidden = true
        return view
    }()
    
    lazy var speedLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "80"
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("Find Routes", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    lazy var actionSheetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 25.0
        return view
    }()
    
    lazy var actionSheetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "layers")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var actionSheetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15.0
        return button
    }()
    
    
    lazy var currentLocationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 25.0
        return view
    }()
    
    lazy var currentLocationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icnCompas")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15.0
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .systemBlue
        button.isHidden = true
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
        imageView.image = UIImage(named: "locIcon")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var locationIconOrigin: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "locIconorigin")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var locationIconLine: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "locIconline")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var locationIconDestination: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "locIcondestination")
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
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tableView
    }()
    
    lazy var routesTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 15.0
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tableView
    }()
    
    lazy var mainTableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    lazy var potentialReward: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  Potential Rewards 500 Drives  "
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.000)
        label.textColor = .black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 9
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
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "location")
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
    
    lazy var weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 23.5
        view.isHidden = true
        return view
    }()
    
    lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "weather")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        return label
    }()
    
    lazy var carButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.9)
        button.setImage(UIImage(named: "carIcon"), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    
    lazy var alertTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notice"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    lazy var alertDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DriveSafe & Earn Mode"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    lazy var alertSeparaterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    lazy var alertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("Go", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.backgroundColor = .lightGray
        activityView.color = .white
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        activityView.transform = transfrom
        activityView.layer.cornerRadius = 5
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        return activityView
    }()
    
    var showRoutes = false
    
    public func configrations() {
        
        let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/mapbox/dark-v11"))
        let mapView = MapView(frame: view.bounds, mapInitOptions: options)
        GMSPlacesClient.provideAPIKey("AIzaSyAMlml7aqa1BQRUnmmmgixmFoDR3mdpRUI")
        placesClient = GMSPlacesClient.shared()
        navigationMapView = NavigationMapView(frame: view.bounds, mapView: mapView)
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationMapView.userLocationStyle = .puck2D()
        navigationMapView.delegate = self
        navigationMapView.mapView.isUserInteractionEnabled = true
        navigationMapView.mapView.ornaments.compassView.topAnchor.constraint(equalTo: navigationMapView.topAnchor, constant: 290).isActive = true
        initialDestinationButton.addTarget(self, action:#selector(self.initialDestinationButtonTapped), for: .touchUpInside)
        actionSheetButton.addTarget(self, action:#selector(self.actionSheetButtonTapped), for: .touchUpInside)
        currentLocationButton.addTarget(self, action:#selector(self.currentLocationButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        alertButton.addTarget(self, action:#selector(self.alertOkButtonTapped), for: .touchUpInside)
        getUserLocation()
        let speedLimitView = SpeedLimitView()
        navigationMapView.addSubview(speedLimitView)
        DispatchQueue.main.async {
            self.initialSubViewSetup()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        addDoneButtonToKeyboard()
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCell")
        routesTableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteTableViewCell")
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
            getWeather(location: lastLocation.coordinate)
            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil {
                    if let firstLocation = placemarks?[0],
                       let cityName = firstLocation.locality {
                        if let selectedPlaces = SharePreference.shared.getSelectedPlaces() {
                            if selectedPlaces.count == 0 {
                                self?.findPlaces(query: cityName)
                            }
                        } else {
                            self?.findPlaces(query: cityName)
                        }
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
                        self.places = selectedPlaces.reversed()
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
    
    func getWeather(location: CLLocationCoordinate2D) {
        APIService.shared.getWeather(location: location) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weatherLabel.text = NSString(format:"\(weather.temp)%@C" as NSString, "\u{00B0}") as String
                    self.weatherView.isHidden = false
                    self.weatherImage.load(url: weather.iconURL)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePlace(_ place: Place) {
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
    
    @objc func initialDestinationButtonTapped(sender: UIButton) {
        if let selectedPlaces = SharePreference.shared.getSelectedPlaces() {
            if selectedPlaces.count != 0 {
                self.places = selectedPlaces.reversed()
                showRoutes = false
                self.tableView.reloadData()
            }
        }
        showRoutes = false
        onCancel()
        addSubViewsOnDestinationTap()
        backButton.isHidden = false
    }
    
    
    @objc func actionSheetButtonTapped(sender: UIButton) {
        let vc = SelectMapStyleViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    @objc func currentLocationButtonTapped(sender: UIButton) {
        setCurrentLocation()
    }
    
    @objc func backButtonTapped(sender: UIButton) {
        onCancel()
    }
    
    @objc func startNavigationAction(sender: UIButton) {
        startNavigation()
    }
    
    @objc func carDriveModeAction(sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alertView.alpha = 1.0
            self.alertView.isHidden = false
        }) { _ in
            print("")
        }
    }
    
    @objc func alertOkButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alertView.alpha = 0
            self.alertView.isHidden = true
        }) { _ in
            print("")
        }
    }
    
    func setCurrentLocation() {
        let cameraOptions = CameraOptions(center: backupOriginCordinates,
                                          padding: .zero,
                                          anchor: .zero,
                                          zoom: 15.0,
                                          bearing: 180.0,
                                          pitch: 15.0)
        
        self.navigationMapView.mapView.camera.ease(to: cameraOptions, duration: 4.0)
    }
    
    func startNavigation() {
        if let destination = destination {
            if destination != backupOriginCordinates {
                if origin == backupOriginCordinates {
                    navigationRouteTurnByTurn(origin: origin!, destination: destination)
                } else {
                    showAlert(message: ORIGIN_LOCATION_TEXT)
                }
            } else {
                showAlert(message: DESTINATION_LOCATION_TEXT)
            }
        }
    }
    
    func showAlert(message: String, showSettingAlert: Bool = false) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        if showSettingAlert {
            alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        } else {
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func findRouteAction(sender: UIButton) {
        showRoutes = true
        guard origin != nil  else {
            showAlert(message: TURN_LOCATION_TEXT, showSettingAlert: true)
            return
        }
        indicatorView.center = self.view.center
        self.view.addSubview(indicatorView)
        if let destination  = destination, let originLocation = origin {
            requestRoute(origin: originLocation, destination: destination)
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
                
                let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: strongSelf.currentRouteIndex)
                let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                simulating: .never)
                
                let topBanner = CustomTopBarViewController()
                let bottomBanner = CustomBottomBarViewController()
                bottomBanner.cancelDelegate = self
                let navigationOptions = NavigationOptions(styles: [CustomNightStyles()], navigationService: navigationService,
                                                          topBanner: topBanner,
                                                          bottomBanner: bottomBanner)
                let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                        navigationOptions: navigationOptions)
                bottomBanner.navigationViewController = navigationViewController
                
                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.showsSpeedLimits = false
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
                strongSelf.speedLimitOuterView.addSubview(strongSelf.speedLimitLabel)
                mapView.insertSubview(strongSelf.speedLimitOuterView, aboveSubview: strongSelf.currentSpeedView)
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
                    strongSelf.currentSpeedView.widthAnchor.constraint(equalToConstant: 60),
                    strongSelf.speedLabel.topAnchor.constraint(equalTo: strongSelf.currentSpeedView.topAnchor, constant: 12),
                    strongSelf.speedLabel.centerXAnchor.constraint(equalTo: strongSelf.currentSpeedView.centerXAnchor),
                    strongSelf.speedLabel.heightAnchor.constraint(equalToConstant: 20),
                    strongSelf.speedLabel.widthAnchor.constraint(equalToConstant: 45),
                    strongSelf.kilometerPerHour.topAnchor.constraint(equalTo: strongSelf.speedLabel.bottomAnchor, constant: 2),
                    strongSelf.kilometerPerHour.centerXAnchor.constraint(equalTo: strongSelf.speedLabel.centerXAnchor),
                    
                    strongSelf.speedLimitOuterView.leadingAnchor.constraint(equalTo: strongSelf.currentSpeedView.trailingAnchor, constant: -8),
                    strongSelf.speedLimitOuterView.centerYAnchor.constraint(equalTo: strongSelf.currentSpeedView.centerYAnchor),
                    strongSelf.speedLimitOuterView.heightAnchor.constraint(equalToConstant: 36),
                    strongSelf.speedLimitOuterView.widthAnchor.constraint(equalToConstant: 36),
                    strongSelf.speedLimitLabel.topAnchor.constraint(equalTo: strongSelf.speedLimitOuterView.topAnchor, constant: 0),
                    strongSelf.speedLimitLabel.leadingAnchor.constraint(equalTo: strongSelf.speedLimitOuterView.leadingAnchor, constant: 0),
                    strongSelf.speedLimitLabel.trailingAnchor.constraint(equalTo: strongSelf.speedLimitOuterView.trailingAnchor, constant: 0),
                    strongSelf.speedLimitLabel.bottomAnchor.constraint(equalTo: strongSelf.speedLimitOuterView.bottomAnchor, constant: 0)
                ])
                
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
    func requestRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        indicatorView.startAnimating()
        view.isUserInteractionEnabled = false
        let navigationRouteOptions = NavigationRouteOptions(coordinates: [origin, destination])
        navigationRouteOptions.includesAlternativeRoutes = true
        let cameraOptions = CameraOptions(center: origin, zoom: 12.0)
        self.navigationMapView.mapView.mapboxMap.setCamera(to: cameraOptions)
        
        Directions.shared.calculate(navigationRouteOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                self?.view.isUserInteractionEnabled = true
                self?.indicatorView.stopAnimating()
                self?.showAlert(message: error.localizedDescription)
                print(error.localizedDescription)
            case .success(let response):
                self?.view.isUserInteractionEnabled = true
                self?.indicatorView.stopAnimating()
                guard let routes = response.routes,
                      let currentRoute = routes.first,
                      let self = self else { return }
                
                self.routeResponse = response
                self.navigationMapView.show(routes)
                self.navigationMapView.showWaypoints(on: currentRoute)
                
                self.manageSubViewOnFindRouteAction1()
                if self.showRoutes {
                    self.routesTableView.reloadData()
                }
            }
        }
    }
    
    func populateRouteView(route: Route) {
        
        let kilometers = Measurement(value: route.distance, unit: UnitLength.meters).converted(to: .kilometers)
        let meters = Measurement(value: route.distance, unit: UnitLength.meters).converted(to: .meters)
        let distanceInKilometers = Int(kilometers.value)
        if distanceInKilometers != 0 {
            self.routeDistance.text = "\(distanceInKilometers) km"
        } else {
            let meters = Int(meters.value)
            self.routeDistance.text = "\(meters) m"
        }
        
        let expectedTime = self.secondsToHoursMinutesSeconds(Int(route.expectedTravelTime))
        if expectedTime.0 != 0{
            self.routeTime.text = "\(expectedTime.0) h" + " " + "\(expectedTime.1) m"
        } else {
            self.routeTime.text = "\(expectedTime.1) m"
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
        let limit = 80.0
        
        if let _ = navigationViewController.navigationView.speedLimitView.speedLimit?.value  {
            if speedInKilometers > limit {
                kilometerPerHour.textColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.4784313725, alpha: 1)
                speedLabel.textColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.4784313725, alpha: 1)
                speedLimitLabel.textColor = .white
                speedLimitOuterView.backgroundColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.4784313725, alpha: 1)
                speedLimitOuterView.isHidden = false
            } else {
                kilometerPerHour.textColor = #colorLiteral(red: 0.003921568627, green: 0.8, blue: 0.08235294118, alpha: 1)
                speedLabel.textColor = #colorLiteral(red: 0.003921568627, green: 0.8, blue: 0.08235294118, alpha: 1)
                speedLimitOuterView.isHidden = true
            }
        }
        
        let currentSpeed = String(format: "%.0f", speedInKilometers)
        speedLabel.text = currentSpeed
    }
    
    public func navigationMapView(_ navigationMapView: MapboxNavigation.NavigationMapView, didSelect route: MapboxDirections.Route) {
        currentRouteIndex = routes?.firstIndex(of: route) ?? 0
        populateRouteView(route: route)
    }
}

extension MapBoxViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == routesTableView {
            return self.routeResponse?.routes?.count ?? 0
        } else {
            if isFromOrigin || isFromDestination {
                return places.count + 1
            }
            return places.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == routesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for:indexPath) as! RouteTableViewCell
            if let routes = self.routeResponse?.routes, !routes.isEmpty {
                let route = routes[indexPath.row]
                cell.populateRouteView(route: route, location: locationName.text, indexPath: indexPath.row)
            }
            cell.startRouteClosure = { [weak self] in
                if let routes = self?.routeResponse?.routes {
                    self?.currentRouteIndex = routes.firstIndex(of: routes[indexPath.row]) ?? 0
                    self?.startNavigation()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for:indexPath) as! LocationTableViewCell
            cell.backgroundColor = .green
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
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == routesTableView {
            return 125
        } else {
            return 46
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        guard !showRoutes else { return }
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
                self.savePlace(place)
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
            self.savePlace(place)
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
        showRoutes = false
        if let constraint = (self.mainTableView.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = 193
        }
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

extension MapBoxViewController: SelectedMapStyle {
    func selectedStyle(type: String) {
    navigationMapView.mapView.mapboxMap.style.uri = StyleURI(rawValue: type)//StyleURI.satellite

    }
}

extension MapBoxViewController: CustomCancelNavigationDegate {
    func onCancel() {
        UIView.transition(with: self.view, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.navigationButton.removeFromSuperview()
            self.routeMainView.removeFromSuperview()
            self.mainTableView.removeFromSuperview()
            self.tableView.removeFromSuperview()
            self.initialDestinationView.removeFromSuperview()
            self.searchMapsTextField.removeFromSuperview()
            self.serachImageView.removeFromSuperview()
            self.destinationMainView.removeFromSuperview()
            self.initialDestinationMainView.removeFromSuperview()
            self.originSubView.removeFromSuperview()
            self.originTextField.removeFromSuperview()
            self.destinationSubView.removeFromSuperview()
            self.locationIcon.removeFromSuperview()
            self.destinationTextField.removeFromSuperview()
            self.routesTableView.removeFromSuperview()
            
            self.initialSubViewSetup()
        }, completion: nil)
        
        showRoutes = false
        self.routeResponse = nil
        self.tableView.reloadData()
        backButton.isHidden = true
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
