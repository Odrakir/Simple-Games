//
//  ServiceProvider.swift
//  Games Extension
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {
    
    override init() {
        super.init()
    }
    
    // MARK: - TVTopShelfProvider protocol
    
    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .Sectioned
    }
    
    var topShelfItems: [TVContentItem] {
        
        var contentItems = [TVContentItem]();
        
        var item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "theWall", container: nil)!)
        item!.imageURL = NSBundle.mainBundle().URLForResource("thewall.png", withExtension: nil)
        item!.imageShape = .HDTV
        
        item!.displayURL = NSURL(string: "launchgame://theWall")
        item!.title = "The Wall"
        contentItems.append(item!)
        
        item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "columns", container: nil)!)
        item!.imageURL = NSBundle.mainBundle().URLForResource("columns.png", withExtension: nil)
        item!.imageShape = .HDTV
        
        item!.displayURL = NSURL(string: "launchgame://columns")
        item!.title = "Columns"
        contentItems.append(item!)
        
        
        // SET THE SECTION DETAILS
        let sectionItem = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "contentIdentifier", container: nil)!)
        sectionItem!.title = "Simple Games"
        sectionItem!.topShelfItems = contentItems
        
        
        return [sectionItem!]
    }

}

