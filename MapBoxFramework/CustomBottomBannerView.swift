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
        
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomBottomBannerView", bundle: bundle)

        bundle.loadNibNamed("CustomBottomBannerView", owner: self)
        
//        Bundle.main.loadNibNamed(String(describing: CustomBottomBannerView.self),
//                                 owner: self,
//                                 options: nil)

        
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        crossImage.image = UIImage(systemName: "multiply")
        cancelButton.backgroundColor = .clear
//        progressBar.progressTintColor = .systemGreen
//        progressBar.layer.borderColor = UIColor.black.cgColor
//        progressBar.layer.borderWidth = 2
//        progressBar.layer.cornerRadius = 5
        
        cancelButton.backgroundColor = .systemGray
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(.darkGray, for: .highlighted)
        
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

