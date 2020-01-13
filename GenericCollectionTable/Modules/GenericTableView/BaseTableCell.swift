//
//  BaseTableCell.swift
//  GenericTableCollection
//
//  Created by jeevan  on 08/10/19.
//  Copyright © 2019 jeevan . All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell{
    
    var data: Any?
    weak var parentInstance: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

