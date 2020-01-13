//
//  DataSourceDelegate.swift
//  Wallet_Prod
//
//  Created by jeevan  on 18/09/19.
//  Copyright © 2019 com.ome97.wallet. All rights reserved.
//

import UIKit

open class GenericCollectionSection{
    var reusableCollectionView: UICollectionReusableView.Type?
    var reusableViewSize:       CGSize
    var sectionData:            Any?
    var collectionRows:         [GenericCollectionRows]?
    
    //MARK: Provide collection view section Header and data
    init(
        reusableCollectionView: UICollectionReusableView.Type?  = nil,
        reusableViewSize:       CGSize                          = CGSize(width: 0, height: 0),
        sectionData:            Any?                            = nil,
        collectionRows:         [GenericCollectionRows]?        = nil
    ) {
        self.reusableCollectionView                             = reusableCollectionView
        self.reusableViewSize                                   = reusableViewSize
        self.sectionData                                        = sectionData
        self.collectionRows                                     = collectionRows
    }
}

open class GenericCollectionRows{
    var collectionCell:         UICollectionViewCell.Type?
    var rowData:                Any?
    var itemSize:               CGSize
    
    //MARK: Provide collection view row cell and data
    init(
        collectionCell: UICollectionViewCell.Type?              = nil,
        rowData:        Any?                                    = nil,
        itemSize:       CGSize                                  = CGSize(width: 0, height: 0)
    ){
        self.collectionCell                                     = collectionCell
        self.rowData                                            = rowData
        self.itemSize                                           = itemSize
    }
    
}


//MARK: COLLECTION VIEW DATA SOURCE AND DELEGATE

public class DataSourceCollection: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var data: [GenericCollectionSection]?
    weak var controller: UIViewController?
    var selection: CollectionTableSelection?
    var startScrolling: StartScrolling?
    var endScrolling: EndScrolling?
    var startScrollinWithTopView: StartScrollingWithTopView?
    var lastContentOffset: CGFloat = 0
    var topViewHeight: CGFloat = 0{
        didSet{
            currentHeight = topViewHeight
        }
    }
    var currentHeight: CGFloat = 0
    
    
    init(controller: UIViewController? = nil,withData: [GenericCollectionSection]? = nil, collectionView: UICollectionView, selection: CollectionTableSelection? = nil, startScrolling: StartScrolling? = nil, endScrolling: EndScrolling? = nil){
        super.init()
        self.controller = controller
        self.data = withData
        collectionView.dataSource = self
        collectionView.delegate =   self
        self.selection = selection
        self.startScrolling = startScrolling
        self.endScrolling = endScrolling
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return
            data?[indexPath.section].collectionRows?[indexPath.item].itemSize ?? CGSize(width: 0, height: 0)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?[section].collectionRows?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.cell(collectionViewCell: data?[indexPath.section].collectionRows?[indexPath.item].collectionCell ?? UICollectionViewCell.self, forIndex: indexPath, withCellDetails: data?[indexPath.section].collectionRows?[indexPath.item].rowData, controller: controller)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return data?[section].reusableViewSize ?? CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.header(headerView: data?[indexPath.section].reusableCollectionView ?? UICollectionReusableView.self, forIndex: indexPath, withCellDetails: data?[indexPath.section].sectionData, controller: controller)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection?(indexPath)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentIndex = Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width)
        endScrolling?(currentIndex)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var value: CGFloat = 0
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            if currentHeight == 0 { return }
            if currentHeight < topViewHeight + 1{
                value = currentHeight - abs(lastContentOffset - scrollView.contentOffset.y)
                if value < 0 { value = 0 }
                currentHeight = value
            }
        }else if (self.lastContentOffset > scrollView.contentOffset.y){
            if currentHeight == topViewHeight { return }
            if currentHeight < topViewHeight + 1{
                value = currentHeight + abs(lastContentOffset - scrollView.contentOffset.y)
                if value > topViewHeight { value = topViewHeight }
                currentHeight = value
            }
        }else { }
        
        lastContentOffset = scrollView.contentOffset.y
        startScrolling?(scrollView)
        startScrollinWithTopView?(scrollView, currentHeight)
    }
    
}


extension DataSourceCollection{
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    //        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
    //            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    //            cell.contentView.backgroundColor =
    //
    //                #colorLiteral(red: 0.4117647059, green: 0.3058823529, blue: 1, alpha: 0.3)
    //        }, completion: nil)
    //
    //
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    //        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
    //            cell.transform = .identity
    //            cell.contentView.backgroundColor = .clear
    //        }, completion: nil)
    //    }
}
