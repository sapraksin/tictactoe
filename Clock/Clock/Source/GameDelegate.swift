//
//  GameDelegate.swift
//  Clock
//
//  Created by Станислав Апраксин on 20.01.2021.
//

import Foundation

protocol GameDelegate: class {
    
    func gameDidChangeState(_ state: Game.State)
    func gameCurrentMove(player: Player)
    func gameFinished(win player: Player?)
}
