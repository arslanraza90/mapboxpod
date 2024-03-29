//
//  LocationTableViewCell.swift
//  mapboxpod
//
//  Created by Arslan Raza on 28/02/2023.
//


import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let placeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Suggested location 1"
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var serachImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image  = UIImage(named: "reload")
         imageView.tintColor = .darkGray
         return imageView
     }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.addSubview(cellView)
        contentView.addSubview(serachImageView)
        cellView.addSubview(placeName)
        
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        cellView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        serachImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8).isActive = true
        serachImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        serachImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        serachImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        placeName.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0).isActive = true
        placeName.leadingAnchor.constraint(equalTo: serachImageView.trailingAnchor, constant: 10).isActive = true
        placeName.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
        placeName.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
    }
    
    
}
