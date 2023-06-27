//
//  CustomBottomBannerView.swift
//  mapboxpod
//
//  Created by Arslan Raza on 04/04/2023.
//

import Foundation
import UIKit

protocol CustomBottomBannerViewDelegate: AnyObject {
    func customBottomBannerDidCancel(_ banner: CustomBottomBannerView)
}

class CustomBottomBannerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var arrivalView: UIView!
    @IBOutlet weak var minuteView: UIView!
    @IBOutlet weak var kmView: UIView!
    @IBOutlet weak var drivesView: UIView!
    
    var eta: String? {
        get {
            return etaLabel.text
        }
        set {
            etaLabel.text = newValue
        }
    }
    
    var timeTotal: String? {
        get {
            return totalTime.text
        }
        set {
            totalTime.text = newValue
        }
    }
    
    var distanceTotal: String? {
        get {
            return totalDistance.text
        }
        set {
            totalDistance.text = newValue
        }
    }
    
    
    weak var delegate: CustomBottomBannerViewDelegate?
    
    private func initFromNib() {
        
        Bundle.main.loadNibNamed(String(describing: CustomBottomBannerView.self),
                                 owner: self,
                                 options: nil)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(.darkGray, for: .highlighted)
        mainView.layer.cornerRadius = 14.5
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        
//        layer.shadowColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1).cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 0 , height:5)
//        layer.shadowRadius = 3
        
        arrivalView.layer.shadowColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1).cgColor
        arrivalView.layer.shadowOffset = CGSize(width: 0, height: 3)
        arrivalView.layer.shadowOpacity = 0.7
        arrivalView.layer.shadowRadius = 4.0
        
        minuteView.layer.shadowColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1).cgColor
        minuteView.layer.shadowOffset = CGSize(width: 0, height: 3)
        minuteView.layer.shadowOpacity = 0.7
        minuteView.layer.shadowRadius = 4.0
        
        kmView.layer.shadowColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1).cgColor
        kmView.layer.shadowOffset = CGSize(width: 0, height: 3)
        kmView.layer.shadowOpacity = 0.7
        kmView.layer.shadowRadius = 4.0
        
        drivesView.layer.shadowColor = #colorLiteral(red: 0.2, green: 0.9529411765, blue: 0.6666666667, alpha: 1).cgColor
        drivesView.layer.shadowOffset = CGSize(width: 0, height: 3)
        drivesView.layer.shadowOpacity = 0.7
        drivesView.layer.shadowRadius = 4.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        delegate?.customBottomBannerDidCancel(self)
    }
}

