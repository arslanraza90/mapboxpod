//
//  CustomBottomBarViewController.swift
//  MapBoxFramework
//
//  Created by Arslan Raza on 14/04/2023.
//

import UIKit
import MapboxNavigation
import CoreLocation
import MapboxCoreNavigation

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
