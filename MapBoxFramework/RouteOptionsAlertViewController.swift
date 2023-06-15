//
//  RouteOptionsAlertViewController.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/14/23.
//

import UIKit

class RouteOptionsAlertViewController: UIViewController {
    
    lazy var routeOptionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var routeOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Route options"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var avoidRoadTollsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Avoid Road Tolls", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    
    lazy var avoidHazardsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "check"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Avoid Hazards", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    
    lazy var avoidTrafficButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Avoid Traffic", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    
    
    lazy var avoidRestrictedRoadsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Avoid Restricted Roads", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.layer.borderWidth = 1.0
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(routeOptionsView)
        routeOptionsView.addSubview(routeOptionLabel)
        routeOptionsView.addSubview(avoidRoadTollsButton)
        routeOptionsView.addSubview(avoidHazardsButton)
        routeOptionsView.addSubview(avoidTrafficButton)
        routeOptionsView.addSubview(avoidRestrictedRoadsButton)
        routeOptionsView.addSubview(cancelButton)
        routeOptionsView.addSubview(doneButton)
        
        
        NSLayoutConstraint.activate([
            routeOptionsView.widthAnchor.constraint(equalToConstant: 272),
            routeOptionsView.heightAnchor.constraint(equalToConstant: 261),
            routeOptionsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            routeOptionsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            routeOptionLabel.leadingAnchor.constraint(equalTo: routeOptionsView.leadingAnchor, constant: 15),
            routeOptionLabel.topAnchor.constraint(equalTo: routeOptionsView.topAnchor, constant: 24),
            
            avoidRoadTollsButton.leadingAnchor.constraint(equalTo: routeOptionsView.leadingAnchor, constant: 24),
            avoidRoadTollsButton.topAnchor.constraint(equalTo: routeOptionLabel.bottomAnchor, constant: 15),
            avoidRoadTollsButton.heightAnchor.constraint(equalToConstant: 18),
            
            avoidHazardsButton.leadingAnchor.constraint(equalTo: avoidRoadTollsButton.leadingAnchor),
            avoidHazardsButton.topAnchor.constraint(equalTo: avoidRoadTollsButton.bottomAnchor, constant: 10),
            avoidHazardsButton.heightAnchor.constraint(equalToConstant: 18),
            
            avoidTrafficButton.leadingAnchor.constraint(equalTo: avoidHazardsButton.leadingAnchor),
            avoidTrafficButton.topAnchor.constraint(equalTo: avoidHazardsButton.bottomAnchor, constant: 10),
            avoidTrafficButton.heightAnchor.constraint(equalToConstant: 18),
            
            avoidRestrictedRoadsButton.leadingAnchor.constraint(equalTo: avoidTrafficButton.leadingAnchor),
            avoidRestrictedRoadsButton.topAnchor.constraint(equalTo: avoidTrafficButton.bottomAnchor, constant: 10),
            avoidRestrictedRoadsButton.heightAnchor.constraint(equalToConstant: 18),
            
            cancelButton.leadingAnchor.constraint(equalTo: routeOptionsView.leadingAnchor, constant: 15),
            cancelButton.topAnchor.constraint(equalTo: avoidRestrictedRoadsButton.bottomAnchor, constant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 37),
            cancelButton.widthAnchor.constraint(equalToConstant: 110),
            
            doneButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20),
            doneButton.topAnchor.constraint(equalTo: avoidRestrictedRoadsButton.bottomAnchor, constant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 37),
            doneButton.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        avoidRoadTollsButton.addTarget(self, action: #selector(avoidRoadTollsAction(_:)), for: .touchUpInside)
        avoidHazardsButton.addTarget(self, action: #selector(avoidHazardsAction(_:)), for: .touchUpInside)
        avoidTrafficButton.addTarget(self, action: #selector(avoidTrafficAction(_:)), for: .touchUpInside)
        avoidRestrictedRoadsButton.addTarget(self, action: #selector(avoidRestrictedRoadsAction(_:)), for: .touchUpInside)
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func avoidRoadTollsAction(_ sender: UIButton) {
        avoidRoadTollsButton.setImage(UIImage(named: "check"), for: .normal)
        avoidHazardsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidTrafficButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidRestrictedRoadsButton.setImage(UIImage(named: "uncheck"), for: .normal)
    }
    
    @objc func avoidHazardsAction(_ sender: UIButton) {
        avoidRoadTollsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidHazardsButton.setImage(UIImage(named: "check"), for: .normal)
        avoidTrafficButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidRestrictedRoadsButton.setImage(UIImage(named: "uncheck"), for: .normal)
    }
    
    @objc func avoidTrafficAction(_ sender: UIButton) {
        avoidRoadTollsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidHazardsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidTrafficButton.setImage(UIImage(named: "check"), for: .normal)
        avoidRestrictedRoadsButton.setImage(UIImage(named: "uncheck"), for: .normal)
    }
    
    @objc func avoidRestrictedRoadsAction(_ sender: UIButton) {
        avoidRoadTollsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidHazardsButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidTrafficButton.setImage(UIImage(named: "uncheck"), for: .normal)
        avoidRestrictedRoadsButton.setImage(UIImage(named: "check"), for: .normal)
    }
}
