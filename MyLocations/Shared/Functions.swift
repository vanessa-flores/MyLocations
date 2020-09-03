//
//  Functions.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/2/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import Foundation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name("CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
