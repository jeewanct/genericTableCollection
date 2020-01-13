//
//  BaseCollectionCell.swift
//  GenericTableCollection
//
//  Created by jeevan  on 08/10/19.
//  Copyright © 2019 jeevan . All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell{
    
    weak var controller: UIViewController?
    var data: Any?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
