//
//  NearestPlacesViewController.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import UIKit
import Foundation
import CoreLocation
import MapboxNavigation
import MapboxMaps

protocol NearestLocationDelegate: AnyObject {
    func onDirectionAction(location: Location, name: String)
}

class NearestPlacesViewController: UIViewController {
    
    lazy var nearestPlacesTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 15.0
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        return textField
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var gifImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .darkGray
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        imageView.loadGif(name: "loader")
        imageView.isHidden = true
        return imageView
    }()
    
    weak var delegate: NearestLocationDelegate?
    
    var placeType: PlacesType = .grocerystore
    var origin: CLLocationCoordinate2D?
    var catogories = allCategories
    
    var placesResults: [Results] = []
    
    var filterPlacesResults: [Results] = [] {
        didSet {
            DispatchQueue.main.async {
                self.nearestPlacesTableView.reloadData()
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if origin != nil {
            findNearestLocation()
        }
        
    }
    
    var navigationMapView: NavigationMapView!
    
    func setupViews() {
        navigationMapView = NavigationMapView(frame: view.bounds)
        navigationMapView.userLocationStyle = .puck2D()
        navigationMapView.mapView.mapboxMap.style.uri = StyleURI(rawValue: "mapbox://styles/mapbox/dark-v11")
        view.addSubview(navigationMapView)
        
        view.backgroundColor = .clear
        view.addSubview(nearestPlacesTableView)
        view.addSubview(categoryCollectionView)
        searchView.addSubview(serachImageView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(filterButton)
        view.addSubview(searchView)
        view.addSubview(backButton)
        view.addSubview(gifImage)
        
        NSLayoutConstraint.activate([
            gifImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            gifImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            gifImage.heightAnchor.constraint(equalToConstant: 100),
            gifImage.widthAnchor.constraint(equalToConstant: 100),
            
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            searchView.heightAnchor.constraint(equalToConstant: 45),
            searchView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            searchView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 15),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
    
            serachImageView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 8),
            serachImageView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            serachImageView.heightAnchor.constraint(equalToConstant: 20),
            serachImageView.widthAnchor.constraint(equalToConstant: 20),
            
            searchTextField.leadingAnchor.constraint(equalTo: serachImageView.trailingAnchor, constant: 8),
            searchTextField.centerYAnchor.constraint(equalTo: serachImageView.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -10),
    
            filterButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -5),
            filterButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 30),
            filterButton.widthAnchor.constraint(equalToConstant: 30),
            
            categoryCollectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 3),
            categoryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            nearestPlacesTableView.topAnchor.constraint(equalTo: self.categoryCollectionView.bottomAnchor, constant: 15),
            nearestPlacesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            nearestPlacesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            nearestPlacesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
        ])
        nearestPlacesTableView.register(NearestPlaceTableViewCell.self, forCellReuseIdentifier: NearestPlaceTableViewCell.identifier)
        nearestPlacesTableView.dataSource = self
        nearestPlacesTableView.delegate = self
        backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addDoneButtonToKeyboard()
    }
    
    func addDoneButtonToKeyboard() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction(sender:)))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.searchTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction(sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func findNearestLocation() {
        guard let locationCoordinate = origin  else { return}
        gifImage.isHidden = false
        view.isUserInteractionEnabled = false
        GooglePlacesManager.shared.getNearestLocation(placeType: self.placeType, locationCoordinate: locationCoordinate) { (response, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.gifImage.isHidden = true
            }
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let results = response {
                self.placesResults = results
                self.filterPlacesResults = results
            }
        }
    }
    
    func findPlaceDetails(_ placeId: String) {
        GooglePlacesManager.shared.findPlaceDetails(placeId) { (response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let placeDetails = response {
                guard let phoneNumber = placeDetails.result?.formatted_phone_number?.filter({!$0.isWhitespace}) else {
                    DispatchQueue.main.async {
                        Common.showAlert(message: "Contact information not available", viewController: self)
                    }
                    return }
                if let phoneUrl = URL(string: "tel://\(phoneNumber)") {
                    if UIApplication.shared.canOpenURL(phoneUrl) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonTapped(sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            if searchText != "" {
                filterPlacesResults = searchItems(searchText: searchText)
            } else {
                filterPlacesResults = placesResults
            }
        }
    }
    
    func searchItems(searchText: String) -> [Results] {
        let filteredItems = placesResults.filter { ($0.name?.lowercased() ?? "").contains(searchText.lowercased()) }
        return filteredItems
    }
}

extension NearestPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPlacesResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearestPlaceTableViewCell.identifier, for:indexPath) as! NearestPlaceTableViewCell
        cell.backgroundColor = .clear
        let place = filterPlacesResults[indexPath.row]
        if let coordinates = origin {
            cell.configurePlaceCell(place, type: self.placeType, originCoordinate: coordinates)
        }
        cell.callClosure = { [weak self] in
            if let placeId = place.place_id {
                self?.findPlaceDetails(placeId)
            }
        }
        cell.directionClosure = { [weak self] in
            if let location = place.geometry?.location, let name = place.name {
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.onDirectionAction(location: location, name: name)
                })
            }
        }
        return cell
    }
}

extension NearestPlacesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.setCellData(allCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        allCategories.forEach({$0.isselected = false })
        allCategories[indexPath.row].isselected = true
        self.categoryCollectionView.reloadData()
        self.placeType = allCategories[indexPath.row].type
        findNearestLocation()
    }
}
