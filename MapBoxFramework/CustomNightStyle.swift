//
//  CustomNightStyle.swift
//  MapBox
//
//  Created by Arslan Raza on 14/02/2023.
//

import Foundation
import MapboxNavigation

class CustomNightStyles: NightStyle {
    
    required init() {
        super.init()
        
        styleType = .night
    }
    
    override func apply() {
        super.apply()
        let traitCollection = UIScreen.main.traitCollection
        InstructionsBannerView.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        
    }
}
