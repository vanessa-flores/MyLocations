//
//  Functions.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/2/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
