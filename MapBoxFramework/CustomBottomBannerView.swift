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
    @IBOutlet weak var crossImage: UIImageView!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var mainView: UIView!
    
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
        crossImage.image = UIImage(named: "cross")
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(.darkGray, for: .highlighted)
        mainView.layer.cornerRadius = 14.5
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
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

