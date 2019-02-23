import UIKit

struct CardViewModel{
    let title: String
    let price: Int
    let image: UIImage
    
    static func dummyModels()->[CardViewModel] {
        return [
            CardViewModel(title: "NewYork", price: 15000, image: #imageLiteral(resourceName: "newyork")),
            CardViewModel(title: "Prague", price: 4000, image: #imageLiteral(resourceName: "prague")),
            CardViewModel(title: "Mars", price: 3500, image: #imageLiteral(resourceName: "mars")),
        CardViewModel(title: "NewYork", price: 15000, image: #imageLiteral(resourceName: "newyork")),
        CardViewModel(title: "Prague", price: 4000, image: #imageLiteral(resourceName: "prague")),
        CardViewModel(title: "Mars", price: 3500, image: #imageLiteral(resourceName: "mars"))]
        
    }
}
