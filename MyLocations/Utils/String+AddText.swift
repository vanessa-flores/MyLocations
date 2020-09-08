//
//  String+AddText.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/8/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
