//
//  Game.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import Foundation

final class Game {
    
    private let player1: Player
    private let player2: Player
    private let board: Board
    
    private var currentPlayer: Player
    private lazy var counter = board.rows * board.columns
    
    private var state: State = .stopped {
        didSet { delegate?.gameDidChangeState(state) }
    }
    
    weak var delegate: GameDelegate?
    
    init(board: Board, player1: Player, player2: Player) {
        self.board = board
        self.player1 = player1
        self.player2 = player2
        
        currentPlayer = player1
    }
    
    func loop(_ node: Node) {
        let new = self.node(node)
        
        guard board.insert(new) else {
            return
        }
        
        swapPlayers()
        checkWin()
    }
    
    func resetGame() {
        state = .resumed
        
        counter = board.rows * board.columns
        currentPlayer = player1
        
        board.clean()
    }
}

private extension Game {
    
    func swapPlayers() {
        if currentPlayer.uuid == player1.uuid {
            currentPlayer = player2
        } else {
            currentPlayer = player1
        }
        delegate?.gameCurrentMove(player: currentPlayer)
    }
    
    func checkWin() {
        let win1 = checkWin(for: player1)
        let win2 = checkWin(for: player2)
        
        switch (win1, win2) {
        case (true, false):
            state = .finished
            delegate?.gameFinished(win: player1)
        case (false, true):
            state = .finished
            delegate?.gameFinished(win: player2)
        case (false, false) where counter == 0:
            state = .finished
            delegate?.gameFinished(win: nil)
        default:
            return
        }
    }
    
    func updateCounter() {
        counter -= 1
    }
}

private extension Game {
    
    func node(_ node: Node) -> Node {
        guard node.kind == .empty else {
            return node
        }
        
        return Node(
            x: node.x,
            y: node.y,
            kind: currentPlayer.kind
        )
    }
    
    func checkWin(for player: Player) -> Bool {
        return checkDiagonal(for: player.kind) || checkLines(for: player.kind)
    }
    
    func checkDiagonal(for kind: Node.Kind) -> Bool {
        var left = true
        var right = true
        
        let nodes = board.nodes
        
        for i in 0..<nodes.count {
            right = right && nodes[i][i].kind == kind
            left = left && nodes[nodes.count - i - 1][i].kind == kind
        }
        
        guard left || right else {
            return false
        }
        
        return true
    }
    
    func checkLines(for kind: Node.Kind) -> Bool {
        var rows = true
        var columns = true
        
        let nodes = board.nodes
        
        for x in 0..<nodes.count {
            rows = true
            columns = true
            
            for y in 0..<nodes[x].count {
                rows = rows && nodes[y][x].kind == kind
                columns = columns && nodes[x][y].kind == kind
            }
            
            guard rows || columns else {
                return false
            }
            
            return true
        }
        
        return false
    }
}

extension Game {
    
    enum State {
        case stopped
        case resumed
        case finished
    }
}
