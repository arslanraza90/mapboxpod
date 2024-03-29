//
//  MapBoxViewController+Extension.swift
//  mapboxpod
//
//  Created by Arslan Raza on 01/03/2023.
//

import Foundation
import UIKit

extension MapBoxViewController {
    
    func initialSubViewSetup() {
        
        view.addSubview(navigationMapView)
        navigationMapView.addSubview(currentLocationView)
        currentLocationView.addSubview(currentLocationImageView)
        currentLocationView.addSubview(currentLocationButton)
        navigationMapView.addSubview(actionSheetView)
        actionSheetView.addSubview(actionSheetImageView)
        actionSheetView.addSubview(actionSheetButton)
        navigationMapView.addSubview(initialDestinationMainView)
        initialDestinationMainView.addSubview(initialDestinationView)
        initialDestinationView.addSubview(initialDestinationLabel)
        initialDestinationView.addSubview(initialDestinationButton)
        initialDestinationView.addSubview(serachImageView)
        
        NSLayoutConstraint.activate([
            
            actionSheetView.leadingAnchor.constraint(equalTo: navigationMapView.leadingAnchor, constant: UIScreen.main.bounds.width - 60),
            actionSheetView.topAnchor.constraint(equalTo: navigationMapView.topAnchor, constant: 160),
            actionSheetView.heightAnchor.constraint(equalToConstant: 50),
            actionSheetView.widthAnchor.constraint(equalToConstant: 50),
            
            currentLocationView.leadingAnchor.constraint(equalTo: navigationMapView.leadingAnchor, constant: UIScreen.main.bounds.width - 60),
            currentLocationView.topAnchor.constraint(equalTo: navigationMapView.topAnchor, constant: 230),
            currentLocationView.heightAnchor.constraint(equalToConstant: 50),
            currentLocationView.widthAnchor.constraint(equalToConstant: 50),
            
            currentLocationImageView.centerYAnchor.constraint(equalTo: currentLocationView.centerYAnchor),
            currentLocationImageView.centerXAnchor.constraint(equalTo: currentLocationView.centerXAnchor),
            currentLocationImageView.heightAnchor.constraint(equalToConstant: 25),
            currentLocationImageView.widthAnchor.constraint(equalToConstant: 25),
            
            currentLocationButton.trailingAnchor.constraint(equalTo: currentLocationView.trailingAnchor, constant: 0),
            currentLocationButton.topAnchor.constraint(equalTo: currentLocationView.topAnchor, constant: 0),
            currentLocationButton.bottomAnchor.constraint(equalTo: currentLocationView.bottomAnchor, constant: 0),
            currentLocationButton.leadingAnchor.constraint(equalTo: currentLocationView.leadingAnchor, constant: 0),
            
            actionSheetImageView.centerYAnchor.constraint(equalTo: actionSheetView.centerYAnchor),
            actionSheetImageView.centerXAnchor.constraint(equalTo: actionSheetView.centerXAnchor),
            actionSheetImageView.heightAnchor.constraint(equalToConstant: 25),
            actionSheetImageView.widthAnchor.constraint(equalToConstant: 25),
            
            actionSheetButton.trailingAnchor.constraint(equalTo: actionSheetView.trailingAnchor, constant: 0),
            actionSheetButton.topAnchor.constraint(equalTo: actionSheetView.topAnchor, constant: 0),
            actionSheetButton.bottomAnchor.constraint(equalTo: actionSheetView.bottomAnchor, constant: 0),
            actionSheetButton.leadingAnchor.constraint(equalTo: actionSheetView.leadingAnchor, constant: 0),
            
            initialDestinationMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            initialDestinationMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            initialDestinationMainView.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -100),
            initialDestinationMainView.heightAnchor.constraint(equalToConstant: 72),
            
            initialDestinationView.leadingAnchor.constraint(equalTo: initialDestinationMainView.leadingAnchor, constant: 15),
            initialDestinationView.trailingAnchor.constraint(equalTo: initialDestinationMainView.trailingAnchor, constant: -15),
            initialDestinationView.bottomAnchor.constraint(equalTo: initialDestinationMainView.bottomAnchor, constant: -16),
            initialDestinationView.topAnchor.constraint(equalTo: initialDestinationMainView.topAnchor, constant: 17),
            
            serachImageView.leadingAnchor.constraint(equalTo: initialDestinationView.leadingAnchor, constant: 8),
            serachImageView.centerYAnchor.constraint(equalTo: initialDestinationView.centerYAnchor),
            serachImageView.heightAnchor.constraint(equalToConstant: 20),
            serachImageView.widthAnchor.constraint(equalToConstant: 20),
            
            initialDestinationLabel.leadingAnchor.constraint(equalTo: serachImageView.trailingAnchor, constant: 12),
            initialDestinationLabel.centerYAnchor.constraint(equalTo: serachImageView.centerYAnchor),
            initialDestinationLabel.heightAnchor.constraint(equalToConstant: 20),
            initialDestinationLabel.widthAnchor.constraint(equalToConstant: 150),
            
            initialDestinationButton.centerXAnchor.constraint(equalTo: initialDestinationMainView.centerXAnchor),
            initialDestinationButton.centerYAnchor.constraint(equalTo: initialDestinationMainView.centerYAnchor),
            initialDestinationButton.heightAnchor.constraint(equalTo: initialDestinationMainView.heightAnchor),
            initialDestinationButton.widthAnchor.constraint(equalTo: initialDestinationMainView.widthAnchor),
            
        ])
    }
    
    func addSubViewsOnDestinationTap() {
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.initialDestinationMainView.removeFromSuperview()
            self.initialDestinationLabel.removeFromSuperview()
            self.initialDestinationButton.removeFromSuperview()

        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.mainTableView)

        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.initialDestinationMainView)

        }, completion: nil)
        
        mainTableView.addSubview(tableView)
        navigationMapView.addSubview(initialDestinationMainView)
        initialDestinationMainView.addSubview(initialDestinationView)
        initialDestinationView.addSubview(searchMapsTextField)
        initialDestinationView.addSubview(serachImageView)
        tableView.delegate = self
        tableView.dataSource = self
        searchMapsTextField.delegate = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationTableViewCell")
        
        NSLayoutConstraint.activate([
            
            mainTableView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            mainTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            mainTableView.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -100),
            mainTableView.heightAnchor.constraint(equalToConstant: 193),
            
            tableView.centerXAnchor.constraint(equalTo: mainTableView.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: mainTableView.centerYAnchor),
            tableView.heightAnchor.constraint(equalTo: mainTableView.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: mainTableView.widthAnchor),
            
            initialDestinationMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            initialDestinationMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            initialDestinationMainView.bottomAnchor.constraint(equalTo: mainTableView.topAnchor, constant: -10),
            initialDestinationMainView.heightAnchor.constraint(equalToConstant: 72),
            
            initialDestinationView.leadingAnchor.constraint(equalTo: initialDestinationMainView.leadingAnchor, constant: 15),
            initialDestinationView.trailingAnchor.constraint(equalTo: initialDestinationMainView.trailingAnchor, constant: -15),
            initialDestinationView.bottomAnchor.constraint(equalTo: initialDestinationMainView.bottomAnchor, constant: -16),
            initialDestinationView.topAnchor.constraint(equalTo: initialDestinationMainView.topAnchor, constant: 17),
            
            serachImageView.leadingAnchor.constraint(equalTo: initialDestinationView.leadingAnchor, constant: 8),
            serachImageView.centerYAnchor.constraint(equalTo: initialDestinationView.centerYAnchor),
            serachImageView.heightAnchor.constraint(equalToConstant: 20),
            serachImageView.widthAnchor.constraint(equalToConstant: 20),
            
            searchMapsTextField.leadingAnchor.constraint(equalTo: serachImageView.trailingAnchor, constant: 12),
            searchMapsTextField.centerYAnchor.constraint(equalTo: serachImageView.centerYAnchor),
            searchMapsTextField.heightAnchor.constraint(equalToConstant: 20),
            searchMapsTextField.trailingAnchor.constraint(equalTo: initialDestinationView.trailingAnchor, constant: -12),
            
        ])
    }
    
    func addSubviewsOnCellSelection() {
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.mainTableView.removeFromSuperview()
            self.initialDestinationMainView.removeFromSuperview()

        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.navigationButton)

        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.destinationMainView)

        }, completion: nil)
        
        destinationMainView.addSubview(originSubView)
        originSubView.addSubview(originTextField)
        destinationMainView.addSubview(destinationSubView)
        destinationMainView.addSubview(locationIcon)
        destinationSubView.addSubview(destinationTextField)
        destinationTextField.delegate = self
        originTextField.delegate = self
        navigationButton.addTarget(self, action:#selector(self.findRouteAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            navigationButton.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            navigationButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            navigationButton.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -30),
            navigationButton.heightAnchor.constraint(equalToConstant: 48),
            
            destinationMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            destinationMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            destinationMainView.bottomAnchor.constraint(equalTo: navigationButton.topAnchor, constant: -20),
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
            
            destinationTextField.leadingAnchor.constraint(equalTo: destinationSubView.leadingAnchor, constant: 12),
            destinationTextField.trailingAnchor.constraint(equalTo: destinationSubView.trailingAnchor, constant: -12),
            destinationTextField.centerYAnchor.constraint(equalTo: destinationSubView.centerYAnchor),
            destinationTextField.heightAnchor.constraint(equalToConstant: 20),
            
            originTextField.leadingAnchor.constraint(equalTo: originSubView.leadingAnchor, constant: 12),
            originTextField.trailingAnchor.constraint(equalTo: originSubView.trailingAnchor, constant: -12),
            originTextField.centerYAnchor.constraint(equalTo: originSubView.centerYAnchor),
            originTextField.heightAnchor.constraint(equalToConstant: 20),
            originTextField.widthAnchor.constraint(equalToConstant: 120),
            
            locationIcon.leadingAnchor.constraint(equalTo: destinationMainView.leadingAnchor, constant: 10),
            locationIcon.bottomAnchor.constraint(equalTo: destinationMainView.bottomAnchor, constant: -17),
            locationIcon.topAnchor.constraint(equalTo: destinationMainView.topAnchor, constant: 20),
            locationIcon.widthAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    func manageSubViewOnFindRouteAction() {
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationButton.removeFromSuperview()
            self.destinationMainView.removeFromSuperview()

        }, completion: nil)
        
        navigationButton.removeFromSuperview()
        destinationMainView.removeFromSuperview()
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.routeMainView)

        }, completion: nil)
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.destinationMainView)

        }, completion: nil)
        
        routeMainView.addSubview(routesLabel)
        routeMainView.addSubview(locationName)
        routeMainView.addSubview(fastestRoute)
        routeMainView.addSubview(routeDistance)
        routeMainView.addSubview(routeTime)
        routeMainView.addSubview(startButtonView)
        startButtonView.addSubview(locationImage)
        startButtonView.addSubview(startLabel)
        startButtonView.addSubview(startButton)
        startButton.addTarget(self, action:#selector(self.startNavigationAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            routeMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            routeMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            routeMainView.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -100),
            routeMainView.heightAnchor.constraint(equalToConstant: 128),
            
            destinationMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            destinationMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            destinationMainView.bottomAnchor.constraint(equalTo: routeMainView.topAnchor, constant: -10),
            destinationMainView.heightAnchor.constraint(equalToConstant: 140),
            
            routesLabel.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            routesLabel.topAnchor.constraint(equalTo: routeMainView.topAnchor, constant: 15),
            routesLabel.heightAnchor.constraint(equalToConstant: 19),
            
            locationName.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            locationName.topAnchor.constraint(equalTo: routesLabel.bottomAnchor, constant: 10),
            locationName.heightAnchor.constraint(equalToConstant: 15),
            locationName.widthAnchor.constraint(equalToConstant: 200),
            
            fastestRoute.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            fastestRoute.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 6),
            fastestRoute.heightAnchor.constraint(equalToConstant: 14),
            
            routeDistance.leadingAnchor.constraint(equalTo: routeMainView.leadingAnchor, constant: 10),
            routeDistance.topAnchor.constraint(equalTo: fastestRoute.bottomAnchor, constant: 6),
            routeDistance.heightAnchor.constraint(equalToConstant: 12),
            
            routeTime.trailingAnchor.constraint(equalTo: routeMainView.trailingAnchor, constant: -15),
            routeTime.centerYAnchor.constraint(equalTo: locationName.centerYAnchor),
            routeTime.heightAnchor.constraint(equalToConstant: 18),
            
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
        
        ])
    }
    
    func manageSubViewsOnTextFieldEditing() {
        
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.navigationMapView.addSubview(self.mainTableView)

        }, completion: nil)
        
        NSLayoutConstraint.activate([
            
            mainTableView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            mainTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            mainTableView.bottomAnchor.constraint(equalTo: navigationMapView.bottomAnchor, constant: -100),
            mainTableView.heightAnchor.constraint(equalToConstant: 193),
            
            destinationMainView.centerXAnchor.constraint(equalTo: navigationMapView.centerXAnchor),
            destinationMainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            destinationMainView.bottomAnchor.constraint(equalTo: mainTableView.topAnchor, constant: -20),
            destinationMainView.heightAnchor.constraint(equalToConstant: 140),
            
        ])
    }
}

