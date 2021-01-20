//
//  Board.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import Foundation

final class Board {
    
    let rows: Int
    let columns: Int
    
    private(set) lazy var nodes: [[Node]] = createNodes()
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }
}

extension Board {
    
    func insert(_ node: Node) -> Bool {
        guard nodes.count > node.x else {
            return false
        }
        
        guard nodes[node.x].count > node.y else {
            return false
        }
        
        let target = nodes[node.x][node.y]
        if target.kind == node.kind {
            return false
        }
        
        nodes[node.x][node.y] = node
        
        return true
    }
    
    func clean() {
        nodes = createNodes()
    }
}

private extension Board {
    
    func createNodes() -> [[Node]] {
        var nodes: [[Node]] = []
        for i in 0..<rows {
            var col: [Node] = []
            
            for j in 0..<columns {
                let node = Node(x: i, y: j, kind: .empty)
                col.append(node)
            }
            
            nodes.append(col)
        }
        
        return nodes
    }
}
