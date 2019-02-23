import UIKit
class CardStackCell: UICollectionViewCell{
    static var reuseId: String = "CardStackCell"
    var viewModel: CardViewModel!{
        didSet{
            titleLabel.text = viewModel.title
            priceLabel.text = String(viewModel.price)
            imageView.image = viewModel.image
        }
    }
    
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let imageView = UIImageView()
    private let detailButton = UIButton()
    private let circleView = UIView()
    private let underlineView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
        setupImageView()
        setupTitleLabel()
        setupPriceLabel()
        setupDetailButton()
        setupCircleView()
        setupUnderlineView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupUnderlineView(){
        cardView.addSubview(underlineView)
        underlineView.backgroundColor = .white
        underlineView.anchor(top: titleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 2))
        underlineView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
    }
    
    
    fileprivate func setupCircleView(){
        cardView.addSubview(circleView)
        circleView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 180, height: 180))
        circleView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        circleView.backgroundColor = .clear
        circleView.layer.cornerRadius = 90
        circleView.layer.masksToBounds = true
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func setupDetailButton(){
        cardView.addSubview(detailButton)
        detailButton.anchor(top: nil, leading: nil, bottom: cardView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 30, right: 0), size: .init(width: 200, height: 35))
        detailButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        detailButton.setTitle("Details", for: .normal)
        detailButton.setTitleColor(.white, for: .normal)
        detailButton.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        detailButton.layer.cornerRadius = 20
        detailButton.layer.masksToBounds = true
        detailButton.layer.borderColor = UIColor.white.cgColor
        detailButton.layer.borderWidth = 1
    }
    
    fileprivate func setupCardView(){
        contentView.addSubview(cardView)
        
        
        contentView.addConstraints([
            NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.9, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.75, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ])
        
        
        
        cardView.layer.cornerRadius = 8
        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    fileprivate func setupImageView(){
        cardView.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    fileprivate func setupTitleLabel(){
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: cardView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
    fileprivate func setupPriceLabel(){
        cardView.addSubview(priceLabel)
        priceLabel.textColor = .white
        priceLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
    }
}
