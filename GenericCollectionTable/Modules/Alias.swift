//
//  Alias.swift
//  GenericTableCollection
//
//  Created by jeevan  on 08/10/19.
//  Copyright © 2019 jeevan . All rights reserved.
//

import UIKit

public typealias CollectionTableSelection = (IndexPath) -> Void
public typealias EndScrolling = (Int) -> Void
public typealias StartScrolling = (UIScrollView) -> Void
public typealias StartScrollingWithTopView = (UIScrollView, CGFloat) -> Void
