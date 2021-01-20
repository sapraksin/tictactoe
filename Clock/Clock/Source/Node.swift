//
//  Node.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import Foundation

struct Node {
    let x: Int
    let y: Int
    
    let kind: Kind
}

extension Node {
    
    enum Kind {
        case cross
        case circle
        case empty
    }
}
