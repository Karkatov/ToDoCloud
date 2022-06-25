

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TasksCollectionViewCell"
    var colorView: UIView = {
        let view = UIView()
        view.alpha = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(colorView)
        addSubview(taskTitleLabel)
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            taskTitleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 15),
            taskTitleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant:  -15),
            taskTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            deleteButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -15),
            deleteButton.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 15),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMySize(_ size: Double) -> UIFont {
        let font = setMySize(size)
        return font
    }
    
    func showButton() {
        deleteButton.pulsate(0)
        deleteButton.opacityAnimation()
    }
}
