//
//  DriveModeCancelAlertViewController.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/14/23.
//

import UIKit

class DriveModeCancelAlertViewController: UIViewController {
    
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
        label.text = "Notice"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    lazy var alertDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you sure you want to cancel driving mode?"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    lazy var alertOkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    lazy var alertCancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    var okDriveModeClosure: (()  -> Void)?
    
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
        alertView.addSubview(alertDescriptionLabel)
        alertView.addSubview(alertOkButton)
        alertView.addSubview(alertCancelButton)

        
        NSLayoutConstraint.activate([
            
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 150),
            alertView.widthAnchor.constraint(equalToConstant: 310),
            
            alertTitleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
            alertTitleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 15),
            
            alertDescriptionLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: 0),
            alertDescriptionLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 15),
            
            alertCancelButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor, constant: -55),
            alertCancelButton.topAnchor.constraint(equalTo: alertDescriptionLabel.bottomAnchor, constant: 25),
            alertCancelButton.widthAnchor.constraint(equalToConstant: 85),
            alertCancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            alertOkButton.leadingAnchor.constraint(equalTo: alertCancelButton.trailingAnchor, constant: 25),
            alertOkButton.topAnchor.constraint(equalTo: alertCancelButton.topAnchor),
            alertOkButton.widthAnchor.constraint(equalToConstant: 85),
            alertOkButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        alertOkButton.addTarget(self, action: #selector(okAction(_:)), for: .touchUpInside)
        alertCancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func okAction(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.okDriveModeClosure?()
        })
    }
}
