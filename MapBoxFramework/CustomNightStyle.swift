//
//  CustomNightStyle.swift
//  MapBox
//
//  Created by Arslan Raza on 14/02/2023.
//

import Foundation
import MapboxNavigation


class CustomNightStyle: NightStyle {

    private let backgroundColor = #colorLiteral(red: 0.06276176125, green: 0.6164312959, blue: 0.3432356119, alpha: 1)
    private let darkBackgroundColor = #colorLiteral(red: 0.0473754704, green: 0.4980872273, blue: 0.2575169504, alpha: 1)
    private let secondaryBackgroundColor = #colorLiteral(red: 0.1335069537, green: 0.133641988, blue: 0.1335278749, alpha: 1)
    private let blueColor = #colorLiteral(red: 0.26683864, green: 0.5903761983, blue: 1, alpha: 1)
    private let lightGrayColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    private let darkGrayColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private let primaryTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private let secondaryTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)

    required init() {
        super.init()
        mapStyleURL = URL(string: "mapbox://styles/mapbox/satellite-streets-v9")!
        styleType = .night
    }

    override func apply() {
        super.apply()

        let traitCollection = UIScreen.main.traitCollection
        DistanceRemainingLabel.appearance(for: traitCollection).normalTextColor = primaryTextColor
        BottomBannerView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
        BottomPaddingView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
        FloatingButton.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.1434620917, green: 0.1434366405, blue: 0.1819391251, alpha: 0.9037466989)
        TimeRemainingLabel.appearance(for: traitCollection).textColor = primaryTextColor
        TimeRemainingLabel.appearance(for: traitCollection).trafficLowColor = primaryTextColor
        TimeRemainingLabel.appearance(for: traitCollection).trafficUnknownColor = primaryTextColor
        ResumeButton.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.1434620917, green: 0.1434366405, blue: 0.1819391251, alpha: 0.9037466989)
        ResumeButton.appearance(for: traitCollection).tintColor = blueColor
    }
}

