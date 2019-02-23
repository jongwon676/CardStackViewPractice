import UIKit

class ViewController: UIViewController {

    var cardViewModels = CardViewModel.dummyModels()
    
    let cardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CardLayout())
    
    func setupbackgroundImage(){
        let last = cardViewModels.count - 1
        if last >= 0 {
            backgroundView.image = cardViewModels[last].image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        setupBackgroundImageView()
        setupBlurEffectView()
        setupCardCollectionView()
        setupbackgroundImage()
        
    }
    
    let backgroundView = UIImageView()
    let blueEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    // MARK: - fileprivate Methods
    
    fileprivate func setupBackgroundImageView(){
        view.addSubview(backgroundView)
        backgroundView.image = #imageLiteral(resourceName: "mars")
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.fillSuperview()
    }
    
    fileprivate func setupBlurEffectView(){
        view.addSubview(blueEffectView)
        blueEffectView.fillSuperview()
    }
    fileprivate func setupCardCollectionView() {
        view.addSubview(cardCollectionView)
        (cardCollectionView.collectionViewLayout as? CardLayout)?.delegate = self
        cardCollectionView.backgroundColor = .clear
        cardCollectionView.register(CardStackCell.self, forCellWithReuseIdentifier: CardStackCell.reuseId)
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        cardCollectionView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: UIScreen.main.bounds.width, height: 480))
        cardCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


// MARK: - datasource && delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: CardStackCell.reuseId, for: indexPath) as! CardStackCell
        cell.viewModel = cardViewModels[indexPath.item]
        return cell
    }
}

extension ViewController: CardLayoutProtocol{
    func cardShouldRemove(_ flowLayout: CardLayout, indexPath: IndexPath) {
        cardViewModels.removeLast()
        cardCollectionView.reloadData()
        setupbackgroundImage()
    }
}

