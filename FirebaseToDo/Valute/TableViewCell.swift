//
//  TableViewCell.swift
//  СurrencyRate
//
//  Created by Duxxless on 26.02.2022.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    static let idenrifire = "CustomTableViewCell"
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    let charLabel: UILabel = {
         let label = UILabel()
         label.textColor = .systemGray
         label.font = UIFont.boldSystemFont(ofSize: 18)
         return label
     }()
    let valueLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
         label.font = UIFont.boldSystemFont(ofSize: 22)
         return label
     }()
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "cloud")
        imageView.image = image
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let borderLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    let borderView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 0/255,
                                              green: 36/255,
                                              blue: 67/255,
                                              alpha: 1)
        borderView.layer.addSublayer(borderLayer)
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(charLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(borderView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = CGRect(x: 20,
                                   y: 80,
                                   width: UIScreen.main.bounds.size.width - 40,
                                   height: 1)
        
        flagImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(20)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            make.width.equalTo(75)
            make.height.equalTo(50)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).inset(-8)
            make.top.equalTo(contentView.snp.top).inset(12)
            make.right.equalTo(contentView.snp.right).inset(90)
        }
        charLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).inset(-8)
            make.bottom.equalTo(contentView.snp.bottom).inset(6)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.bounds.size.height / 2).inset(30)
            make.right.lessThanOrEqualTo(contentView.snp.right).inset(20)
        }
    }
    
    func setCell(object: [String]) {
        flagImageView.image = UIImage(named: object[0])
        charLabel.text = object[0]
        nameLabel.text = object[1]
        valueLabel.text = object[2]
    }
}
