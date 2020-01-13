//
//  Extensions.swift
//  GenericTableCollection
//
//  Created by jeevan  on 08/10/19.
//  Copyright © 2019 jeevan . All rights reserved.
//

import UIKit

extension UITableView{
    func cell<T: UITableViewCell>(tableViewCell: T.Type, withCellDetails data: Any? = nil, controller: UIViewController? = nil) -> T{
        let genericCell = self.dequeueReusableCell(withIdentifier: String(describing: tableViewCell.self)) as! T
        if let baseCell = genericCell as? BaseTableCell{
            baseCell.selectionStyle = .none
            baseCell.parentInstance = controller
            baseCell.data = data
        }
        return genericCell
    }
    
    open func registerCell(cells: UITableViewCell.Type...){
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .none
        cells.forEach { (cell) in
            self.register(UINib(nibName: String(describing: cell.self), bundle: nil), forCellReuseIdentifier: String(describing: cell.self))
        }
    }
}


extension UICollectionView{
    func cell<T: UICollectionViewCell>(collectionViewCell: T.Type,forIndex: IndexPath, withCellDetails data: Any? = nil, controller: UIViewController? = nil) -> T{
        let genericCell = self.dequeueReusableCell(withReuseIdentifier: String(describing: collectionViewCell.self), for: forIndex) as! T
        if let baseCell = genericCell as? BaseCollectionCell{
            baseCell.data = data
            baseCell.controller = controller
        }
        return genericCell
    }
    
    func header<T: UICollectionReusableView>(headerView: T.Type,forIndex: IndexPath, withCellDetails data: Any? = nil, controller: UIViewController? = nil) -> T{
        let genericView = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: headerView.self), for: forIndex) as! T
        if let baseCell = genericView as? BaseCollectionReusableView{
            baseCell.data = data
            baseCell.controller = controller
        }
        return genericView
    }
    
    
    open func registerCell(cells: UICollectionViewCell.Type...){
        self.showsVerticalScrollIndicator = false
        cells.forEach { (cell) in
            self.register(UINib(nibName: String(describing: cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: cell.self))
        }
    }
    
    open func registerHeaders(headers: UICollectionReusableView.Type...){
        headers.forEach { (header) in
            self.register(UINib(nibName: String(describing: header.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: header.self))
        }
    }
}
