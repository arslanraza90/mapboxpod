//
//  SelectMapStyleViewController.swift
//  MapBoxFramework
//
//  Created by Arslan Raza on 14/04/2023.
//

import UIKit

protocol SelectedMapStyle: AnyObject {
    func selectedStyle(type: String)
}

class SelectMapStyleViewController: UIViewController {

        weak var delegate: SelectedMapStyle?
        
        lazy var backdropView: UIView = {
            let bdView = UIView(frame: self.view.bounds)
            bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            return bdView
        }()
        
        fileprivate let mainActionSheetView: UIView = {
             let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
           return view
        }()
        
        lazy var streetViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleToFill
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/r0Sgrnt/street.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var outDoorViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/vhz54Wq/outDoor.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var lightViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/XLW7Dyc/light.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var darkViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/3Snxcxw/dark.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var sateLightViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/LZqBjqP/satelight.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var sateLightStreetViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/7j7tSr1/satellite-Street.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var navigationDayViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/DzLPsmt/navigation-Day.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var traficNightDayViewImage: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius  = 10.0
            image.clipsToBounds = true
            convertUrlToImage(url: "https://i.ibb.co/XynMQTR/traffic-Night.png", completion: { images in
                DispatchQueue.main.async {
                    image.image = images
                }
            })
            return image
        }()
        
        lazy var streetViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var lightViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var traficNightViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        let streetViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Streets"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let lightViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Light"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let outDoorViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Outdoors"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let darkViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Dark"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let sateLightViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Satellight"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let sateLightStreetViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Satellight"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let navigationDayViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Traffic Day"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        let trafficNightViewLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Traffic Night"
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           return label
         }()
        
        lazy var outDoorViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var darkViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var sateLightViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var sateLightStreetViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        lazy var navigationDayViewButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }()
        
        fileprivate let streetMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let darkMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let outDoorMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let lightMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let sateLightMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let sateLightStreetMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let navigationDayMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        fileprivate let trafficNightMainView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10.0
           return view
        }()
        
        let menuView = UIView()
        let menuHeight = UIScreen.main.bounds.height / 3
        var isPresenting = false
        
        init() {
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .custom
            transitioningDelegate = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .clear
            view.addSubview(backdropView)
            view.addSubview(menuView)
            menuView.addSubview(mainActionSheetView)
            mainActionSheetView.addSubview(streetMainView)
            streetMainView.addSubview(streetViewImage)
            streetMainView.addSubview(streetViewLabel)
            streetMainView.addSubview(streetViewButton)
            mainActionSheetView.addSubview(outDoorMainView)
            outDoorMainView.addSubview(outDoorViewImage)
            outDoorMainView.addSubview(outDoorViewButton)
            outDoorMainView.addSubview(outDoorViewLabel)
            mainActionSheetView.addSubview(lightMainView)
            lightMainView.addSubview(lightViewImage)
            lightMainView.addSubview(lightViewLabel)
            lightMainView.addSubview(lightViewButton)
            mainActionSheetView.addSubview(darkMainView)
            darkMainView.addSubview(darkViewImage)
            darkMainView.addSubview(darkViewLabel)
            darkMainView.addSubview(darkViewButton)
            mainActionSheetView.addSubview(sateLightMainView)
            sateLightMainView.addSubview(sateLightViewImage)
            sateLightMainView.addSubview(sateLightViewLabel)
            sateLightMainView.addSubview(sateLightViewButton)
            mainActionSheetView.addSubview(sateLightStreetMainView)
            sateLightStreetMainView.addSubview(sateLightStreetViewImage)
            sateLightStreetMainView.addSubview(sateLightStreetViewLabel)
            sateLightStreetMainView.addSubview(sateLightStreetViewButton)
            mainActionSheetView.addSubview(navigationDayMainView)
            navigationDayMainView.addSubview(navigationDayViewImage)
            navigationDayMainView.addSubview(navigationDayViewLabel)
            navigationDayMainView.addSubview(navigationDayViewButton)
            mainActionSheetView.addSubview(trafficNightMainView)
            trafficNightMainView.addSubview(traficNightDayViewImage)
            trafficNightMainView.addSubview(trafficNightViewLabel)
            trafficNightMainView.addSubview(traficNightViewButton)
            
            
            menuView.backgroundColor = .red
            menuView.translatesAutoresizingMaskIntoConstraints = false
            menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            NSLayoutConstraint.activate([
                mainActionSheetView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 0),
                mainActionSheetView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 0),
                mainActionSheetView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 0),
                mainActionSheetView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: 0),
                
                streetMainView.topAnchor.constraint(equalTo: mainActionSheetView.topAnchor, constant: 30),
                streetMainView.leadingAnchor.constraint(equalTo: mainActionSheetView.leadingAnchor, constant: 15),
                streetMainView.heightAnchor.constraint(equalToConstant: 85),
                streetMainView.widthAnchor.constraint(equalToConstant: 80),
                
                streetViewImage.centerXAnchor.constraint(equalTo: streetMainView.centerXAnchor),
                streetViewImage.topAnchor.constraint(equalTo: streetMainView.topAnchor, constant: 0),
                streetViewImage.heightAnchor.constraint(equalToConstant: 60),
                streetViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                streetViewLabel.centerXAnchor.constraint(equalTo: streetMainView.centerXAnchor),
                streetViewLabel.bottomAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 0),
                
                
                streetViewButton.topAnchor.constraint(equalTo: streetMainView.topAnchor, constant: 0),
                streetViewButton.leadingAnchor.constraint(equalTo: streetMainView.leadingAnchor, constant: 0),
                streetViewButton.trailingAnchor.constraint(equalTo: streetMainView.trailingAnchor, constant: 0),
                streetViewButton.bottomAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 0),
                
                outDoorMainView.topAnchor.constraint(equalTo: mainActionSheetView.topAnchor, constant: 30),
                outDoorMainView.leadingAnchor.constraint(equalTo: streetMainView.trailingAnchor, constant: 15),
                outDoorMainView.heightAnchor.constraint(equalToConstant: 85),
                outDoorMainView.widthAnchor.constraint(equalToConstant: 80),
                
                outDoorViewImage.topAnchor.constraint(equalTo: outDoorMainView.topAnchor, constant: 0),
                outDoorViewImage.centerXAnchor.constraint(equalTo: outDoorMainView.centerXAnchor),
                outDoorViewImage.heightAnchor.constraint(equalToConstant: 60),
                outDoorViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                outDoorViewButton.topAnchor.constraint(equalTo: outDoorMainView.topAnchor, constant: 0),
                outDoorViewButton.leadingAnchor.constraint(equalTo: outDoorMainView.leadingAnchor, constant: 0),
                outDoorViewButton.trailingAnchor.constraint(equalTo: outDoorMainView.trailingAnchor, constant: 0),
                outDoorViewButton.bottomAnchor.constraint(equalTo: outDoorMainView.bottomAnchor, constant: 0),
                
                outDoorViewLabel.centerXAnchor.constraint(equalTo: outDoorMainView.centerXAnchor),
                outDoorViewLabel.bottomAnchor.constraint(equalTo: outDoorMainView.bottomAnchor, constant: 0),
                
                
                lightMainView.topAnchor.constraint(equalTo: mainActionSheetView.topAnchor, constant: 30),
                lightMainView.leadingAnchor.constraint(equalTo: outDoorMainView.trailingAnchor, constant: 15),
                lightMainView.heightAnchor.constraint(equalToConstant: 85),
                lightMainView.widthAnchor.constraint(equalToConstant: 80),
                
                lightViewImage.topAnchor.constraint(equalTo: lightMainView.topAnchor, constant: 0),
                lightViewImage.centerXAnchor.constraint(equalTo: lightMainView.centerXAnchor),
                lightViewImage.heightAnchor.constraint(equalToConstant: 60),
                lightViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                lightViewButton.topAnchor.constraint(equalTo: lightMainView.topAnchor, constant: 0),
                lightViewButton.leadingAnchor.constraint(equalTo: lightMainView.leadingAnchor, constant: 0),
                lightViewButton.trailingAnchor.constraint(equalTo: lightMainView.trailingAnchor, constant: 0),
                lightViewButton.bottomAnchor.constraint(equalTo: lightMainView.bottomAnchor, constant: 0),
                
                lightViewLabel.centerXAnchor.constraint(equalTo: lightMainView.centerXAnchor),
                lightViewLabel.bottomAnchor.constraint(equalTo: lightMainView.bottomAnchor, constant: 0),
                
                darkMainView.topAnchor.constraint(equalTo: mainActionSheetView.topAnchor, constant: 30),
                darkMainView.leadingAnchor.constraint(equalTo: lightViewButton.trailingAnchor, constant: 15),
                darkMainView.heightAnchor.constraint(equalToConstant: 85),
                darkMainView.widthAnchor.constraint(equalToConstant: 80),
                
                darkViewImage.topAnchor.constraint(equalTo: darkMainView.topAnchor, constant: 0),
                darkViewImage.centerXAnchor.constraint(equalTo: darkMainView.centerXAnchor),
                darkViewImage.heightAnchor.constraint(equalToConstant: 60),
                darkViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                darkViewButton.topAnchor.constraint(equalTo: darkMainView.topAnchor, constant: 0),
                darkViewButton.leadingAnchor.constraint(equalTo: darkMainView.leadingAnchor, constant: 0),
                darkViewButton.trailingAnchor.constraint(equalTo: darkMainView.trailingAnchor, constant: 0),
                darkViewButton.bottomAnchor.constraint(equalTo: darkMainView.bottomAnchor, constant: 0),
                
                darkViewLabel.centerXAnchor.constraint(equalTo: darkMainView.centerXAnchor),
                darkViewLabel.bottomAnchor.constraint(equalTo: darkMainView.bottomAnchor, constant: 0),
                
                sateLightMainView.topAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 30),
                sateLightMainView.leadingAnchor.constraint(equalTo: mainActionSheetView.leadingAnchor, constant: 15),
                sateLightMainView.heightAnchor.constraint(equalToConstant: 85),
                sateLightMainView.widthAnchor.constraint(equalToConstant: 80),
                
                sateLightViewImage.topAnchor.constraint(equalTo: sateLightMainView.topAnchor, constant: 0),
                sateLightViewImage.centerXAnchor.constraint(equalTo: sateLightMainView.centerXAnchor),
                sateLightViewImage.heightAnchor.constraint(equalToConstant: 60),
                sateLightViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                sateLightViewButton.topAnchor.constraint(equalTo: sateLightMainView.topAnchor, constant: 0),
                sateLightViewButton.leadingAnchor.constraint(equalTo: sateLightMainView.leadingAnchor, constant: 0),
                sateLightViewButton.trailingAnchor.constraint(equalTo: sateLightMainView.trailingAnchor, constant: 0),
                sateLightViewButton.bottomAnchor.constraint(equalTo: sateLightMainView.bottomAnchor, constant: 0),

                sateLightViewLabel.centerXAnchor.constraint(equalTo: sateLightMainView.centerXAnchor),
                sateLightViewLabel.bottomAnchor.constraint(equalTo: sateLightMainView.bottomAnchor, constant: 0),
                
                
                sateLightStreetMainView.topAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 30),
                sateLightStreetMainView.leadingAnchor.constraint(equalTo: sateLightMainView.trailingAnchor, constant: 15),
                sateLightStreetMainView.heightAnchor.constraint(equalToConstant: 85),
                sateLightStreetMainView.widthAnchor.constraint(equalToConstant: 80),
                
                sateLightStreetViewImage.topAnchor.constraint(equalTo: sateLightStreetMainView.topAnchor, constant: 0),
                sateLightStreetViewImage.centerXAnchor.constraint(equalTo: sateLightStreetMainView.centerXAnchor),
                sateLightStreetViewImage.heightAnchor.constraint(equalToConstant: 60),
                sateLightStreetViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                sateLightStreetViewButton.topAnchor.constraint(equalTo: sateLightStreetMainView.topAnchor, constant: 0),
                sateLightStreetViewButton.leadingAnchor.constraint(equalTo: sateLightStreetMainView.leadingAnchor, constant: 0),
                sateLightStreetViewButton.trailingAnchor.constraint(equalTo: sateLightStreetMainView.trailingAnchor, constant: 0),
                sateLightStreetViewButton.bottomAnchor.constraint(equalTo: sateLightStreetMainView.bottomAnchor, constant: 0),
                
                sateLightStreetViewLabel.centerXAnchor.constraint(equalTo: sateLightStreetMainView.centerXAnchor),
                sateLightStreetViewLabel.bottomAnchor.constraint(equalTo: sateLightStreetMainView.bottomAnchor, constant: 0),
                
                navigationDayMainView.topAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 30),
                navigationDayMainView.leadingAnchor.constraint(equalTo: sateLightStreetMainView.trailingAnchor, constant: 15),
                navigationDayMainView.heightAnchor.constraint(equalToConstant: 85),
                navigationDayMainView.widthAnchor.constraint(equalToConstant: 80),
                
                navigationDayViewImage.topAnchor.constraint(equalTo: navigationDayMainView.topAnchor, constant: 0),
                navigationDayViewImage.centerXAnchor.constraint(equalTo: navigationDayMainView.centerXAnchor),
                navigationDayViewImage.heightAnchor.constraint(equalToConstant: 60),
                navigationDayViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                navigationDayViewButton.topAnchor.constraint(equalTo: navigationDayMainView.topAnchor, constant: 0),
                navigationDayViewButton.leadingAnchor.constraint(equalTo: navigationDayMainView.leadingAnchor, constant: 0),
                navigationDayViewButton.trailingAnchor.constraint(equalTo: navigationDayMainView.trailingAnchor, constant: 0),
                navigationDayViewButton.bottomAnchor.constraint(equalTo: navigationDayMainView.bottomAnchor, constant: 0),
                
                navigationDayViewLabel.centerXAnchor.constraint(equalTo: navigationDayMainView.centerXAnchor),
                navigationDayViewLabel.bottomAnchor.constraint(equalTo: navigationDayMainView.bottomAnchor, constant: 0),
                
                trafficNightMainView.topAnchor.constraint(equalTo: streetMainView.bottomAnchor, constant: 30),
                trafficNightMainView.leadingAnchor.constraint(equalTo: navigationDayMainView.trailingAnchor, constant: 15),
                trafficNightMainView.heightAnchor.constraint(equalToConstant: 85),
                trafficNightMainView.widthAnchor.constraint(equalToConstant: 80),
                
                traficNightDayViewImage.topAnchor.constraint(equalTo: trafficNightMainView.topAnchor, constant: 0),
                traficNightDayViewImage.centerXAnchor.constraint(equalTo: trafficNightMainView.centerXAnchor),
                traficNightDayViewImage.heightAnchor.constraint(equalToConstant: 60),
                traficNightDayViewImage.widthAnchor.constraint(equalToConstant: 60),
                
                traficNightViewButton.topAnchor.constraint(equalTo: trafficNightMainView.topAnchor, constant: 0),
                traficNightViewButton.leadingAnchor.constraint(equalTo: trafficNightMainView.leadingAnchor, constant: 0),
                traficNightViewButton.trailingAnchor.constraint(equalTo: trafficNightMainView.trailingAnchor, constant: 0),
                traficNightViewButton.bottomAnchor.constraint(equalTo: trafficNightMainView.bottomAnchor, constant: 0),
                
                trafficNightViewLabel.centerXAnchor.constraint(equalTo: trafficNightMainView.centerXAnchor),
                trafficNightViewLabel.bottomAnchor.constraint(equalTo: trafficNightMainView.bottomAnchor, constant: 0),
                
                ])
            
            
            streetViewButton.addTarget(self, action: #selector(streetButtonAction(_:)), for: .touchUpInside)
            outDoorViewButton.addTarget(self, action: #selector(outDoorButtonAction(_:)), for: .touchUpInside)
            lightViewButton.addTarget(self, action: #selector(lightButtonAction(_:)), for: .touchUpInside)
            darkViewButton.addTarget(self, action: #selector(darkButtonAction(_:)), for: .touchUpInside)
            sateLightViewButton.addTarget(self, action: #selector(sateLightButtonAction(_:)), for: .touchUpInside)
            sateLightStreetViewButton.addTarget(self, action: #selector(sateLightStreetButtonAction(_:)), for: .touchUpInside)
            navigationDayViewButton.addTarget(self, action: #selector(navigationDayButtonAction(_:)), for: .touchUpInside)
            traficNightViewButton.addTarget(self, action: #selector(traficNightButtonAction(_:)), for: .touchUpInside)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectMapStyleViewController.handleTap(_:)))
            backdropView.addGestureRecognizer(tapGesture)
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            dismiss(animated: true, completion: nil)
        }
        
        @objc func streetButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/streets-v12")
        }
        
        @objc func outDoorButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/outdoors-v12")
        }
        
        @objc func lightButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/light-v11")
        }
        
        @objc func darkButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/dark-v11")
        }
        
        @objc func sateLightButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/satellite-v9")
        }
        
        @objc func sateLightStreetButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/satellite-streets-v12")
        }
        
        @objc func navigationDayButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/navigation-day-v1")
        }
        
        @objc func traficNightButtonAction(_ sender: UIButton?) {
            delegate?.selectedStyle(type: "mapbox://styles/mapbox/navigation-night-v1")
        }
        
        func getImageFromBundle(name: String) -> UIImage {
            guard let filePath = Bundle(for: type(of: self)).path(forResource: name, ofType: "png"),
                  let image = UIImage(contentsOfFile: filePath) else {
                    fatalError("Image not available")
            }
            return image
        }
    }



extension SelectMapStyleViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
