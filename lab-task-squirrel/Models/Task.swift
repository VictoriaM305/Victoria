//
//  Task.swift
//  lab-task-squirrel
//
//  Created by Victoria McKinnie on 09/13/24.
//

import UIKit
import CoreLocation

class Task {
    let title: String
    let description: String
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }
}

extension Task {
    static var mockedTasks: [Task] {
        return [
            Task(title: "Get a new MacBook Pro for your class",
                 description: "Try to get one with at least 256GB of storage."),
            Task(title: "Wash the dishes",
                 description: "Make sure all pots have been washed and rinsed."),
            Task(title: "Take out the trash",
                 description: "Make sure you tie the bags before throwing them in the dumpster.")
        ]
    }
}

