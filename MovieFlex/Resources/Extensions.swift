//
//  Extensions.swift
//  MovieFlex
//
//  Created by Warln on 20/03/22.
//

import UIKit

extension String {
    func capitalizesFirst() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
