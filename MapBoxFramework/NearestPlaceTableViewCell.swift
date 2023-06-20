//
//  NearestPlaceTableViewCell.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import UIKit
import GooglePlaces
import CoreLocation

class NearestPlaceTableViewCell: UITableViewCell {
    
    static let identifier = "NearestPlaceTableViewCell"
    
    lazy var placeMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "restaurant")
        imageView.tintColor = .darkGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grocery store name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.4"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        label.layer.cornerRadius = 5.0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var ratingView: StarRatingView = {
        let view = StarRatingView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  .white
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grocery Store   0.4 km"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "In-store shopping   Open now"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        return label
    }()
    
    lazy var bottomStakeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 15.0
        return stackView
    }()
    
    lazy var callButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Call", for: .normal)
        button.setImage(UIImage(named: "call"), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    lazy var directionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Directions", for: .normal)
        button.setImage(UIImage(named: "direction"), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Share", for: .normal)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    var callClosure: (()  -> Void)?
    var directionClosure: (()  -> Void)?
    var shareClosure: (()  -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        selectionStyle = .none
        contentView.backgroundColor = .clear
        contentView.addSubview(placeMainView)
        placeMainView.addSubview(placeImage)
        placeMainView.addSubview(placeNameLabel)
        placeMainView.addSubview(ratingLabel)
        placeMainView.addSubview(ratingView)
        placeMainView.addSubview(categoryLabel)
        placeMainView.addSubview(statusLabel)
        placeMainView.addSubview(bottomStakeView)
        bottomStakeView.addArrangedSubview(callButton)
        bottomStakeView.addArrangedSubview(directionButton)
        bottomStakeView.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            
            placeMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            placeImage.leadingAnchor.constraint(equalTo: placeMainView.leadingAnchor, constant: 13),
            placeImage.topAnchor.constraint(equalTo: placeMainView.topAnchor, constant: 14),
            placeImage.heightAnchor.constraint(equalToConstant: 110),
            placeImage.widthAnchor.constraint(equalToConstant: 125),
            
            placeNameLabel.leadingAnchor.constraint(equalTo: placeImage.trailingAnchor, constant: 12),
            placeNameLabel.topAnchor.constraint(equalTo: placeMainView.topAnchor, constant: 15),
            placeNameLabel.trailingAnchor.constraint(equalTo: placeMainView.trailingAnchor, constant: 0),
            
            ratingLabel.leadingAnchor.constraint(equalTo: placeNameLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 8),
            
            ratingView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 10),
            ratingView.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 15),
            ratingView.widthAnchor.constraint(equalToConstant: 100),
            
            categoryLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 6),
            categoryLabel.trailingAnchor.constraint(equalTo: placeMainView.trailingAnchor, constant: -5),
            
            statusLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 6),
            statusLabel.trailingAnchor.constraint(equalTo: placeMainView.trailingAnchor, constant: -5),
            
            bottomStakeView.leadingAnchor.constraint(equalTo: placeMainView.leadingAnchor, constant: 0),
            bottomStakeView.topAnchor.constraint(equalTo: placeImage.bottomAnchor, constant: 15),
            bottomStakeView.trailingAnchor.constraint(equalTo: placeMainView.trailingAnchor, constant: 0),
            bottomStakeView.heightAnchor.constraint(equalToConstant: 55),
        ])
        callButton.addTarget(self, action:#selector(self.callButtonTapped), for: .touchUpInside)
        directionButton.addTarget(self, action:#selector(self.dirctionButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action:#selector(self.shareButtonTapped), for: .touchUpInside)
    }
    
    @objc func callButtonTapped(sender: UIButton) {
        callClosure?()
    }
    
    @objc func dirctionButtonTapped(sender: UIButton) {
        directionClosure?()
    }
    
    @objc func shareButtonTapped(sender: UIButton) {
        shareClosure?()
    }
    
    func configurePlaceCell(_ place: Results, type: PlacesType, originCoordinate: CLLocationCoordinate2D) {
        contentView.backgroundColor = .clear
        placeImage.image = UIImage(named: type.image)
        placeNameLabel.text = place.name
        if let rating = place.rating {
            ratingLabel.text = String(rating)
            self.ratingView.rating = rating
        }
        var status = ""
        if let openNow = place.opening_hours?.open_now {
            status = openNow ? "Open now" : "closed"
        }
        
        if let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng {
            let myLocation = CLLocation(latitude:originCoordinate.latitude, longitude:originCoordinate.longitude)
            let destinationLocation = CLLocation(latitude: lat, longitude: lng)
            let distance = myLocation.distance(from: destinationLocation) / 1000
            if type == .restaurant {
                categoryLabel.text = "Restaurant   \(String(format:"%.02f", distance)) km"
                statusLabel.text = "Dine in . Takeaway . Delivery . \(status)"
            } else if type == .grocerystore {
                categoryLabel.text = "Grocery Store   \(String(format:"%.02f", distance)) km"
                statusLabel.text = "In-store shopping . \(status)"
            } else {
                categoryLabel.text = "Gas Station   \(String(format:"%.02f", distance)) km"
                statusLabel.text = "\(status)"
            }
        }
        
        if let reference = place.photos?.first?.photo_reference {
            ImagesManager.shared.fetchPhotoFromReference(reference) { image in
                self.placeImage.image = image
            }
        }
    }
}
