//
//  ViewController.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var boardView: BoardView = {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview($0)
        
        NSLayoutConstraint.activate([
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            $0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
        ])
        
        $0.addTarget(self, action: #selector(boardPressed), for: .touchUpInside)
        
        return $0
    }(BoardView(board: board))
    
    private lazy var messageLabel: UILabel = {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview($0)
        
        NSLayoutConstraint.activate([
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            $0.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            $0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8)
        ])
        
        return $0
    }(UILabel())
    
    private lazy var board = Board(rows: 3, columns: 3)
    private lazy var player1 = Player(kind: .cross)
    private lazy var player2 = Player(kind: .circle)
    private lazy var game = Game(board: board, player1: player1, player2: player2)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self

        boardView.update()
    }
    
    func restart() {
        game.resetGame()
        boardView.update()
    }
}

extension ViewController: GameDelegate {
    
    func gameDidChangeState(_ state: Game.State) {
        switch state {
        case .stopped:
            break
        case .resumed:
            messageLabel.text = nil
            boardView.isUserInteractionEnabled = true
        case .finished:
            messageLabel.text = nil
            boardView.isUserInteractionEnabled = false
        }
    }
    
    func gameCurrentMove(player: Player) {
        boardView.update()
        
        if player1.uuid == player.uuid {
            messageLabel.text = Localization.movePlayer1
        } else {
            messageLabel.text = Localization.movePlayer2
        }
    }
    
    func gameFinished(win player: Player?) {
        if player1.uuid == player?.uuid {
            messageLabel.text = Localization.winPlayer1
        } else if player2.uuid == player?.uuid {
            messageLabel.text = Localization.winPlayer2
        } else {
            messageLabel.text = Localization.standoff
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.restartInterval, execute: restart)
    }
}

private extension ViewController {
    
    @objc
    func boardPressed(_ sender: BoardView, for event: UIEvent) {
        event.touches(for: sender)?.forEach { touch in
            let point = touch.location(in: sender)
            let node = sender.node(inside: point)
            
            game.loop(node)
        }
    }
}

private extension ViewController {
    
    enum Constants {
        static let restartInterval: TimeInterval = 2.0
    }
    
    enum Localization {
        static let movePlayer1 = "Ход игрока 1"
        static let movePlayer2 = "Ход игрока 2"
        static let winPlayer1 = "Побеждает игрок 1"
        static let winPlayer2 = "Побеждает игрок 2"
        static let standoff = "Ничья"
    }
}
