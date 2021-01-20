//
//  BoardView.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import UIKit

class BoardView: UIControl {
    
    private let board: Board
    
    var color: UIColor = .black
    
    init(board: Board) {
        self.board = board
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            drawBoard(in: ctx, rect: rect)
            drawNodes(in: ctx)
        }
    }
}

extension BoardView {
    
    func node(inside: CGPoint) -> Node {
        let size = cellSize(frame)
        let x = ceilf(Float(inside.x / size.width)) - 1
        let y = ceilf(Float(inside.y / size.height)) - 1
        
        return board.nodes[Int(x)][Int(y)]
    }
    
    func update() {
        setNeedsDisplay()
    }
}

private extension BoardView {
    
    func drawBoard(in ctx: CGContext, rect: CGRect) {
        UIGraphicsPushContext(ctx)
        color.setStroke()
        
        var path = UIBezierPath()
        path.lineWidth = 2
        
        let size = cellSize(rect)
        
        for row in 0...board.rows {
            line(at: row, dimension: .horizontal, size: size, in: &path)
        }
        
        for column in 0...board.columns {
            line(at: column, dimension: .vertical, size: size, in: &path)
        }
        
        path.close()
        path.stroke()
        
        UIGraphicsPopContext()
    }
    
    func drawNodes(in ctx: CGContext) {
        guard board.nodes.count > 0 else { return }
        UIGraphicsPushContext(ctx)
        
        board.nodes.forEach { items in
            items.forEach { node in
                switch node.kind {
                case .cross:
                    drawCross(in: ctx, for: node)
                case .circle:
                    drawCircle(in: ctx, for: node)
                case .empty:
                    break
                }
            }
        }
        
        UIGraphicsPopContext()
    }
    
    func line(at index: Int, dimension: Dimension, size: CGSize, in path: inout UIBezierPath) {
        let start: CGPoint
        let end: CGPoint
        
        switch dimension {
        case .horizontal:
            let position = CGFloat(index) * size.width
            start = CGPoint(x: position, y: 0)
            end = CGPoint(x: position, y: frame.height)
        case .vertical:
            let position = CGFloat(index) * size.height
            start = CGPoint(x: 0, y: position)
            end = CGPoint(x: frame.width, y: position)
        }
        
        path.move(to: start)
        path.addLine(to: end)
    }
    
    func drawCross(in ctx: CGContext, for cell: Node) {
        UIGraphicsPushContext(ctx)
        
        let path = UIBezierPath()
        path.lineWidth = 4
        
        let bounds = self.bounds(for: cell)
        let spacing = bounds.size.width * 0.2
        
        path.move(
            to: CGPoint(x: bounds.origin.x + spacing, y: bounds.origin.y + spacing)
        )
        path.addLine(
            to: CGPoint(x: bounds.width + bounds.origin.x - spacing, y: bounds.height + bounds.origin.y - spacing)
        )
        
        path.move(
            to: CGPoint(x: bounds.origin.x + spacing, y: bounds.height + bounds.origin.y - spacing)
        )
        path.addLine(
            to: CGPoint(x: bounds.width + bounds.origin.x - spacing, y: bounds.origin.y + spacing)
        )
        
        path.close()
        path.stroke()
        
        UIGraphicsPopContext()
    }
    
    func drawCircle(in ctx: CGContext, for cell: Node) {
        UIGraphicsPushContext(ctx)
        
        let path = UIBezierPath()
        path.lineWidth = 4
        
        let bounds = self.bounds(for: cell)
        let spacing = bounds.size.width * 0.2
        
        let center = CGPoint(
            x: bounds.width / 2 + bounds.origin.x,
            y: bounds.height / 2 + bounds.origin.y
        )
        path.addArc(
            withCenter: center,
            radius: (bounds.height - spacing) / 2,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        path.close()
        path.stroke()
        
        UIGraphicsPopContext()
    }
}

private extension BoardView {
    
    func bounds(for cell: Node) -> CGRect {
        let size = cellSize(frame)
        let originX = CGFloat(cell.x) * size.width
        let originY = CGFloat(cell.y) * size.height
        
        return CGRect(
            x: originX,
            y: originY,
            width: size.width,
            height: size.height
        )
    }
    
    func cellSize(_ rect: CGRect) -> CGSize {
        return CGSize(
            width: frame.width / CGFloat(board.rows),
            height: frame.height / CGFloat(board.columns)
        )
    }
}

private extension BoardView {
    
    enum Dimension {
        case horizontal
        case vertical
    }
}
