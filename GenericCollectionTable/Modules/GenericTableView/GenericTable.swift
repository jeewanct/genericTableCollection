//
//  GenericTable.swift
//  GenericTableCollection
//
//  Created by jeevan  on 08/10/19.
//  Copyright © 2019 jeevan . All rights reserved.
//

import UIKit

open class GenericTableSection{
    var tableSectionCell: UITableViewCell.Type?
    var sectionData:      Any?
    var tableRows:        [GenericTableRows]?
    var tableFotter:      UITableViewCell.Type?
    
    //MARK: Provide Table view section Header and data
    init(
        tableSectionCell: UITableViewCell.Type?    = nil,
        sectionData:      Any?                     = nil,
        tableRows:        [GenericTableRows]?      = nil,
        tableFotter:      UITableViewCell.Type?    = nil
    ){
        self.tableSectionCell                      = tableSectionCell
        self.sectionData                           = sectionData
        self.tableRows                             = tableRows
        self.tableFotter                           = tableFotter
    }
    
}

open class GenericTableRows{
    var tableCell:              UITableViewCell.Type?
    var rowData:                Any?
    
    //MARK: Provide collection view row cell and data
    init(
        tableCell: UITableViewCell.Type?                        = nil,
        rowData:        Any?                                    = nil
    ){
        self.tableCell                                          = tableCell
        self.rowData                                            = rowData
      }
    
}

//MARK: TABLE VIEW DATA SOURCE AND DELEGATE
public class TableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    var data: [GenericTableSection]?
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
    
    init(controller: UIViewController? = nil,withData: [GenericTableSection]? = nil, tableView: UITableView, selection: CollectionTableSelection? = nil, startScrolling: StartScrolling? = nil, endScrolling: EndScrolling? = nil){
        
        super.init()
        self.controller = controller
        self.data = withData
        tableView.dataSource = self
        tableView.delegate =   self
        self.selection = selection
        self.startScrolling = startScrolling
        self.endScrolling = endScrolling
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?[section].tableRows?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.cell(tableViewCell: data?[indexPath.section].tableRows?[indexPath.item].tableCell ?? UITableViewCell.self, withCellDetails: data?[indexPath.section].tableRows?[indexPath.item].rowData, controller: controller)
    }
    
}

extension TableDataSource{
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cellType = data?[section].tableSectionCell{
            return tableView.cell(tableViewCell: cellType, withCellDetails: data?[section].sectionData)
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if data?[section].tableSectionCell != nil{
            return UITableView.automaticDimension
        }
        return 0.001
    }
    
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cellType = data?[section].tableFotter{
            return tableView.cell(tableViewCell: cellType, withCellDetails: data?[section].sectionData)
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if data?[section].tableFotter != nil{
            return UITableView.automaticDimension
        }
        return 0.001
    }
    
    
    
}

extension TableDataSource{
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentIndex = Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width)
        endScrolling?(currentIndex)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var value: CGFloat = 0
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            if currentHeight == 0 { return }
            if currentHeight < topViewHeight - 1{
                value = currentHeight - abs(lastContentOffset - scrollView.contentOffset.y)
                if value < 0 { value = 0 }
                currentHeight = value
            }
        }else if (self.lastContentOffset > scrollView.contentOffset.y){
            if currentHeight == topViewHeight { return }
            if currentHeight < topViewHeight - 1{
                value = currentHeight + abs(lastContentOffset - scrollView.contentOffset.y)
                if value > topViewHeight { value = topViewHeight }
                currentHeight = value
            }
        }
        
        lastContentOffset = scrollView.contentOffset.y
        startScrolling?(scrollView)
        startScrollinWithTopView?(scrollView, currentHeight)
    }
}


extension TableDataSource{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(indexPath)
    }
}
