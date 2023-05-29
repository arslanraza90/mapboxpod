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

protocol CustomCancelNavigationDegate: AnyObject {
    func onCancel()
}

class CustomBottomBarViewController: ContainerViewController, CustomBottomBannerViewDelegate {
    
    weak var navigationViewController: NavigationViewController?
    weak var cancelDelegate: CustomCancelNavigationDegate?
    
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
        
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .hour, value: durationRemaining.0, to: Date()) {
            if let date1 = calendar.date(byAdding: .minute, value: durationRemaining.1, to: date) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone.current
                let arrivalTime = dateFormatter.string(from: date1)
                bannerView.eta = arrivalTime
            }
        } else {
            bannerView.eta = ""
        }
        
        if durationRemaining.0 != 0{
            bannerView.timeTotal = "\(expectedTime.0)" + ":" + "\(expectedTime.1)"
        } else {
            bannerView.timeTotal = "\(expectedTime.1)"
        }
        
        
        
        let measurement = Measurement(value: progress.route.distance, unit: UnitLength.meters).converted(to: .kilometers)
        let distanceInKilometers = Int(measurement.value)
        bannerView.distanceTotal = String(distanceInKilometers)
    }
    
    // MARK: - CustomBottomBannerViewDelegate implementation
    
    func customBottomBannerDidCancel(_ banner: CustomBottomBannerView) {
        navigationViewController?.dismiss(animated: true,
                                          completion: {
            self.cancelDelegate?.onCancel()
        })
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
