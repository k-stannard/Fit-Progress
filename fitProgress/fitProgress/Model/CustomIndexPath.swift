//
//  CustomIndexPath.swift
//  fitProgress
//
//  Created by Koty Stannard on 12/20/22.
//

import Foundation

struct CustomIndexPath: Hashable {
    var item: Int
    var section: Int
    var textFieldIndex: Int
    
    init(item: Int, section: Int, textFieldIndex: Int) {
        self.item = item
        self.section = section
        self.textFieldIndex = textFieldIndex
    }
}
