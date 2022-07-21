

import UIKit
import SnapKit

class CustomValuteCell: UITableViewCell {
    
    static let idenrifire = "CustomTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Gill Sans", size: 16)
        label.numberOfLines = 0
        return label
    }()
    private let charLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont(name: "Gill Sans", size: 16)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Gill Sans", size: 20)
        return label
    }()
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "cloud")
        imageView.image = image
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(charLabel)
        contentView.addSubview(valueLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flagImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(15)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            make.width.equalTo(65)
            
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
            make.top.equalTo(contentView.bounds.size.height / 2).inset(25)
            make.right.lessThanOrEqualTo(contentView.snp.right).inset(15)
        }
    }
    
    func setCell(object: [String]) {
        flagImageView.image = UIImage(named: object[0])
        charLabel.text = object[0]
        nameLabel.text = object[1]
        valueLabel.text = object[2]
    }
}
