//
//  StarRatingView.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import Foundation
import UIKit

class StarRatingView: UIView {
    private var starImageViews: [UIImageView] = []
    
    var rating: Double = 0 {
        didSet {
            updateStarImageViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(named: "blackstar") // Set your star icon image here
            starImageViews.append(starImageView)
            addSubview(starImageView)
        }
        
        updateStarImageViews()
    }
    
    private func updateStarImageViews() {
        for i in 0..<starImageViews.count {
            let starImageView = starImageViews[i]
            
            if Double(i) < rating {
                starImageView.image = UIImage(named: "yellowstar") // Set your filled star icon image here
            } else {
                starImageView.image = UIImage(named: "blackstar") // Set your empty star icon image here
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let starSize = CGSize(width: frame.height, height: frame.height)
        let spacing = starSize.width / 2.0
        
        for i in 0..<starImageViews.count {
            let starImageView = starImageViews[i]
            let x = CGFloat(i) * (starSize.width + spacing)
            starImageView.frame = CGRect(origin: CGPoint(x: x, y: 0), size: starSize)
        }
    }
}
