import UIKit
extension Int{
    var cgfloat: CGFloat { return CGFloat(self) }
}

protocol CardLayoutProtocol: class {
    func cardShouldRemove(_ flowLayout: CardLayout, indexPath: IndexPath)
}


class CardLayout: UICollectionViewFlowLayout {
    typealias CellWithIndexPath = (cell: UICollectionViewCell, indexPath: IndexPath)
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let maxOffsetThresholdPercentage: CGFloat = 0.3
    weak var delegate: CardLayoutProtocol?
    
    struct AnimationStuff {
        var startY: CGFloat
        var endY: CGFloat
        var startAlpha: CGFloat
        var endAlpha: CGFloat
        var startScale: CGFloat
        var endScale: CGFloat
    }
    
    
    var animationStuffs = [
        AnimationStuff(startY: CGFloat(0), endY: CGFloat(0), startAlpha: CGFloat(1), endAlpha: CGFloat(1), startScale: CGFloat(1), endScale: CGFloat(1)),
        AnimationStuff(startY: CGFloat(-20), endY: CGFloat(0), startAlpha: CGFloat(0.7), endAlpha: CGFloat(1), startScale: CGFloat(0.95), endScale: CGFloat(1)),
        AnimationStuff(startY: CGFloat(-40), endY: CGFloat(-20), startAlpha: CGFloat(0.3), endAlpha: CGFloat(0.7), startScale: CGFloat(0.9), endScale: CGFloat(0.95)),
        AnimationStuff(startY: CGFloat(-40), endY: CGFloat(-40), startAlpha: CGFloat(0), endAlpha: CGFloat(0.3), startScale: CGFloat(0.9), endScale: CGFloat(0.9))
    ]
    
    func applyCellStartPosition(cell: UICollectionViewCell, order: Int){

        if order >= animationStuffs.count{
            cell.alpha = 0
        }else{
            let startAlpha = animationStuffs[order].startAlpha
            let startScale = animationStuffs[order].startScale
            let startYOffset = animationStuffs[order].startY
            cell.alpha = startAlpha
            cell.transform = CGAffineTransform(scaleX: startScale, y: startScale).concatenating(.init(translationX: 0, y: startYOffset))
            
        }
    }
    func applyCellEndPosition(cell: UICollectionViewCell, order: Int){
        if order >= animationStuffs.count{
            cell.alpha = 0
        }else{
            let endAlpha = animationStuffs[order].endAlpha
            let endScale = animationStuffs[order].endScale
            let endYOffset = animationStuffs[order].endY
            cell.alpha = endAlpha
            cell.transform = CGAffineTransform(scaleX: endScale, y: endScale).concatenating(.init(translationX: 0, y: endYOffset))
        }
    }
    
    func getCellWithIndexPath(_ order: Int) -> (cell: UICollectionViewCell, indexPath: IndexPath)?{
        let count = collectionView?.numberOfItems(inSection: 0) ?? 0
        guard count > order else { return nil}
        let indexPath = IndexPath(item: count - order - 1, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        return (cell: cell, indexPath: indexPath)
        
        // stack은 거꾸로임
    }
    
    
    
    fileprivate func getTotalIndexPaths() -> [IndexPath]{
        var indexPaths: [IndexPath] = []
        if let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 {
            for i in 0...numItems-1 {
                indexPaths.append(IndexPath(item: i, section: 0))
            }
        }
        return indexPaths
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = collectionView?.bounds ?? .zero
        if let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 {
            let order = numItems - indexPath.item - 1
            
            if order < animationStuffs.count {
                let startAlpha = animationStuffs[order].startAlpha
                let startYOffset = animationStuffs[order].startY
                let startScale = animationStuffs[order].startScale
                attributes.alpha = startAlpha
                attributes.transform = CGAffineTransform(scaleX: startScale, y: startScale).concatenating(CGAffineTransform(translationX: 0, y: startYOffset))
            }else{
                attributes.alpha = 0
            }
        }
        
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexPaths = getTotalIndexPaths()
        return indexPaths.map{ layoutAttributesForItem(at: $0)}.compactMap{ $0 }
    }
    
    
    override func prepare() {
        super.prepare()
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(gestureRecognizer:)))
        collectionView?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: collectionView)
        let xOffset = translation.x
        let xMaxOffset = (collectionView?.frame.width ?? 0) * maxOffsetThresholdPercentage
        
        switch gestureRecognizer.state {
        case .changed:
            (0..<4).forEach { (order) in
                if let cardCellWithIndexPath = getCellWithIndexPath(order){
                    let cell = cardCellWithIndexPath.cell
                    let dragPercent = abs(xOffset / (collectionView?.frame.width ?? 1))
                    
                    let yOffsetDelta:CGFloat = (animationStuffs[order].endY - animationStuffs[order].startY) * dragPercent
                    let scaleDelta: CGFloat = (animationStuffs[order].endScale - animationStuffs[order].startScale) * dragPercent
                    let alphaDelta: CGFloat = (animationStuffs[order].endAlpha - animationStuffs[order].startAlpha) * dragPercent
                    
                    
                    let xOffset: CGFloat = (order == 0 ? translation.x : 0)
                    let yOffset = animationStuffs[order].startY + yOffsetDelta
                    let alpha = animationStuffs[order].startAlpha + alphaDelta
                    let scale = animationStuffs[order].startScale + scaleDelta
                    
                    cell.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: xOffset, y: yOffset))
                    cell.alpha = alpha
                }
            }
        case .ended:
            if abs(xOffset) > xMaxOffset {
                if let topCard = getCellWithIndexPath(0){
                    animateAndRemove(left: xOffset < 0, cell: topCard.cell, completion: { [weak self] in
                        guard let `self` = self else { return }
                        self.delegate?.cardShouldRemove(self, indexPath: topCard.indexPath)
                    })
                }
                (1..<3).forEach { (order) in
                    if let cardCellWithIndexPath = getCellWithIndexPath(order){
                        let cell = cardCellWithIndexPath.cell
                        applyCellEndPosition(cell: cell, order: order)
                    }
                }
            }else{
                (0..<4).forEach { (order) in
                    if let cardCellWithIndexPath = getCellWithIndexPath(order){
                        let cell = cardCellWithIndexPath.cell
                        applyCellStartPosition(cell: cell, order: order)
                    }
                }
            }
        default: ()
        }
    }
    private func animateAndRemove(left: Bool, cell: UICollectionViewCell, completion: (() -> ())?){
        let screenWidth = UIScreen.main.bounds.width
        
        UIView.animate(withDuration: 0.15, animations: {
            let xTranslateOffscreen = CGAffineTransform(translationX: left ? -screenWidth : screenWidth, y: 0)
            cell.transform = xTranslateOffscreen
        }) { (_) in
            completion?()
        }
    }
}
