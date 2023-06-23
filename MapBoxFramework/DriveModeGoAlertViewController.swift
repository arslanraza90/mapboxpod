//
//  DriveModeGoAlertViewController.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/23/23.
//

import UIKit

class DriveModeGoAlertViewController: UIViewController {
    
    lazy var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var alertTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DriveSafe & Earn Mode"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    
    lazy var alertGoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("Go", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    lazy var alertCancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.setImage(UIImage(named: "alertCross"), for: .normal)
        return button
    }()
    
    
    var goDriveModeClosure: (()  -> Void)?
    
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
        view.addSubview(alertView)
        alertView.addSubview(alertTitleLabel)
        alertView.addSubview(alertGoButton)
        alertView.addSubview(alertCancelButton)

        
        NSLayoutConstraint.activate([
            
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 140),
            alertView.widthAnchor.constraint(equalToConstant: 310),
            
            alertTitleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
            alertTitleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            
            
            alertGoButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 28),
            alertGoButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -28),
            alertGoButton.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 30),
            alertGoButton.heightAnchor.constraint(equalToConstant: 35),
            
            alertCancelButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            alertCancelButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            alertCancelButton.widthAnchor.constraint(equalToConstant: 20),
            alertCancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        alertGoButton.addTarget(self, action: #selector(goAction(_:)), for: .touchUpInside)
        alertCancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goAction(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.goDriveModeClosure?()
        })
    }
}
