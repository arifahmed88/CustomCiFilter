//
//  FilterCollectionViewCell.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/14/22.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var holderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellViewSet()
        
    }
    
    func setlabelText(text:String){
        label.text = text
    }
    
    func cellViewSet(){
        self.layer.cornerRadius = self.bounds.size.height*0.5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red:255/255, green:87/255, blue:25/255, alpha: 1).cgColor
    }

}
