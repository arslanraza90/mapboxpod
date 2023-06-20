//
//  CategoryCollectionViewCell.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    lazy var roundedMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Restaurants"
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "restaurant1")
        imageView.tintColor = .darkGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(roundedMainView)
        roundedMainView.addSubview(label)
        roundedMainView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            roundedMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            roundedMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roundedMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roundedMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: roundedMainView.leadingAnchor, constant: 6),
            imageView.topAnchor.constraint(equalTo: roundedMainView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: roundedMainView.bottomAnchor, constant: -4),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: roundedMainView.trailingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: roundedMainView.centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(_ category: Category) {
        label.text = category.name
        roundedMainView.backgroundColor = category.isselected ? .black : .white
        label.textColor = category.isselected ? .white : .black
        imageView.image = UIImage(named: category.image)
    }
}
