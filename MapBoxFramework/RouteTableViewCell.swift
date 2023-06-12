//
//  RouteTableViewCell.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 5/30/23.
//

import UIKit
import MapboxDirections

class RouteTableViewCell: UITableViewCell {
    
    static let identifier = "RouteTableViewCell"
    
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
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .black
        label.layer.cornerRadius = 5.0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .right
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
        label.text = "  Potential Rewards 500 DRIVES  "
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
        button.isEnabled = true
        return button
    }()
    
    lazy var sepratorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 0
        return view
    }()
    
    var startRouteClosure: (()  -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(routeMainView)
        routeMainView.addSubview(routesLabel)
        routeMainView.addSubview(locationName)
        routeMainView.addSubview(fastestRoute)
        routeMainView.addSubview(routeTime)
        routeMainView.addSubview(routeDistance)
        routeMainView.addSubview(potentialReward)
        routeMainView.addSubview(startButtonView)
        startButtonView.addSubview(locationImage)
        routeMainView.addSubview(startLabel)
        routeMainView.addSubview(startButton)
        routeMainView.addSubview(sepratorView)
        
        NSLayoutConstraint.activate([
            
            routeMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            routeMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            routeMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            routeMainView.heightAnchor.constraint(equalToConstant: 125),
            
            routesLabel.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            routesLabel.topAnchor.constraint(equalTo: routeMainView.topAnchor, constant: 5),
            routesLabel.heightAnchor.constraint(equalToConstant: 17),
            
            locationName.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            locationName.topAnchor.constraint(equalTo: routesLabel.bottomAnchor, constant: 10),
            locationName.heightAnchor.constraint(equalToConstant: 15),
            locationName.trailingAnchor.constraint(equalTo: routeTime.leadingAnchor, constant: -2),
            
            fastestRoute.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            fastestRoute.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 7),
            fastestRoute.heightAnchor.constraint(equalToConstant: 14),
            
            routeDistance.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            routeDistance.topAnchor.constraint(equalTo: fastestRoute.bottomAnchor, constant: 6),
            routeDistance.heightAnchor.constraint(equalToConstant: 12),
            
            potentialReward.leadingAnchor.constraint(equalTo: routeDistance.leadingAnchor, constant: 0),
            potentialReward.topAnchor.constraint(equalTo: routeDistance.bottomAnchor, constant: 9),
            potentialReward.heightAnchor.constraint(equalToConstant: 20),
            
            routeTime.trailingAnchor.constraint(equalTo: routeMainView.trailingAnchor, constant: -10),
            routeTime.centerYAnchor.constraint(equalTo: locationName.centerYAnchor),
            routeTime.heightAnchor.constraint(equalToConstant: 18),
            routeTime.widthAnchor.constraint(lessThanOrEqualToConstant: 85),
            
            startButtonView.trailingAnchor.constraint(equalTo: routeMainView.trailingAnchor, constant: -15),
            startButtonView.topAnchor.constraint(equalTo: routeTime.bottomAnchor, constant: 10),
            startButtonView.heightAnchor.constraint(equalToConstant: 34),
            startButtonView.widthAnchor.constraint(equalToConstant: 76),
            
            locationImage.leadingAnchor.constraint(equalTo: startButtonView.leadingAnchor, constant: 8),
            locationImage.centerYAnchor.constraint(equalTo: startButtonView.centerYAnchor),
            locationImage.heightAnchor.constraint(equalToConstant: 15),
            locationImage.widthAnchor.constraint(equalToConstant: 15),
            
            startLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 6),
            startLabel.centerYAnchor.constraint(equalTo: locationImage.centerYAnchor),
            startLabel.heightAnchor.constraint(equalToConstant: 17),
            startLabel.widthAnchor.constraint(equalToConstant: 33),
            
            startButton.centerXAnchor.constraint(equalTo: startButtonView.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: startButtonView.centerYAnchor),
            startButton.heightAnchor.constraint(equalTo: startButtonView.heightAnchor),
            startButton.widthAnchor.constraint(equalTo: startButtonView.widthAnchor),
            
            sepratorView.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor),
            sepratorView.trailingAnchor.constraint(equalTo: routeMainView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(equalTo: routeMainView.bottomAnchor, constant: 0),
            sepratorView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        startButton.addTarget(self, action:#selector(self.onStartRoute), for: .touchUpInside)
    }
    
    func populateRouteView(route: Route, location: String?, indexPath: Int) {
        startButton.isEnabled = true
        routesLabel.isHidden = indexPath == 0 ? false : true
        fastestRoute.text = indexPath == 0 ? "Fastest Route now" : "Slower Route, more closures"
        if indexPath != 0 {
            if let constraint = (self.routesLabel.constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant = 0
            }
            UIView.transition(with: self.contentView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.contentView.layoutIfNeeded()
                self.routesLabel.layoutIfNeeded()
            }, completion: nil)
        }
        
        
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
        
        locationName.text = location
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func onStartRoute(_ sender: UIButton) {
        startButton.isEnabled = false
        self.startRouteClosure?()
    }
}
