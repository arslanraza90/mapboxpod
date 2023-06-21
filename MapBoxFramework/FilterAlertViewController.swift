//
//  FilterAlertViewController.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/21/23.
//

import UIKit

class FilterAlertViewController: UIViewController {
    
    lazy var filtersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    lazy var filtersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filters"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var allFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "check"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("All", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    
    lazy var topRatedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "check"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Top rated", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    
    lazy var openButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Open now", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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
    
    var filterType: PlaceFilterType = .All
    var doneFilterClosure: ((_ filterType: PlaceFilterType)  -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setSelectedType()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(filtersView)
        filtersView.addSubview(filtersLabel)
        filtersView.addSubview(allFilterButton)
        filtersView.addSubview(topRatedButton)
        filtersView.addSubview(openButton)
        filtersView.addSubview(cancelButton)
        filtersView.addSubview(doneButton)
        
        
        NSLayoutConstraint.activate([
            filtersView.widthAnchor.constraint(equalToConstant: 272),
            filtersView.heightAnchor.constraint(equalToConstant: 240),
            filtersView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            filtersView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            filtersLabel.leadingAnchor.constraint(equalTo: filtersView.leadingAnchor, constant: 15),
            filtersLabel.topAnchor.constraint(equalTo: filtersView.topAnchor, constant: 24),
            
            allFilterButton.leadingAnchor.constraint(equalTo: filtersView.leadingAnchor, constant: 24),
            allFilterButton.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 15),
            allFilterButton.heightAnchor.constraint(equalToConstant: 22),
            
            topRatedButton.leadingAnchor.constraint(equalTo: allFilterButton.leadingAnchor),
            topRatedButton.topAnchor.constraint(equalTo: allFilterButton.bottomAnchor, constant: 10),
            topRatedButton.heightAnchor.constraint(equalToConstant: 22),
            
            openButton.leadingAnchor.constraint(equalTo: topRatedButton.leadingAnchor),
            openButton.topAnchor.constraint(equalTo: topRatedButton.bottomAnchor, constant: 10),
            openButton.heightAnchor.constraint(equalToConstant: 22),
            
            
            cancelButton.leadingAnchor.constraint(equalTo: filtersView.leadingAnchor, constant: 15),
            cancelButton.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 37),
            cancelButton.widthAnchor.constraint(equalToConstant: 110),
            
            doneButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20),
            doneButton.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 37),
            doneButton.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        allFilterButton.addTarget(self, action: #selector(filterButtonsTapped(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(filterButtonsTapped(_:)), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(filterButtonsTapped(_:)), for: .touchUpInside)
    }
    
    func setSelectedType() {
        resetAllButtonsUI()
        switch self.filterType {
        case .All:
            allFilterButton.setImage(UIImage(named: "check"), for: .normal)
        case .TopRated:
            topRatedButton.setImage(UIImage(named: "check"), for: .normal)
        case .Open:
            openButton.setImage(UIImage(named: "check"), for: .normal)
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: UIButton) {
        doneFilterClosure?(filterType)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func filterButtonsTapped(_ sender: UIButton) {
        resetAllButtonsUI()
        sender.setImage(UIImage(named: "check"), for: .normal)
        if sender == allFilterButton {
            filterType = .All
        } else if sender == topRatedButton {
            filterType = .TopRated
        } else if sender == openButton {
            filterType = .Open
        }
    }
    
    func resetAllButtonsUI() {
        allFilterButton.setImage(UIImage(named: "uncheck"), for: .normal)
        topRatedButton.setImage(UIImage(named: "uncheck"), for: .normal)
        openButton.setImage(UIImage(named: "uncheck"), for: .normal)
    }
}
