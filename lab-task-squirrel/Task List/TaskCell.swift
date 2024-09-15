//
//  TaskCell.swift
//  lab-task-squirrel
//
//  Created by Victoria McKinnie on 09/13/24.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // Adjusting appearance
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        
        titleLabel.textColor = task.isComplete ? .secondaryLabel : .label
        
        completedImageView.image = UIImage(systemName: task.isComplete ? "circle.inset.filled" : "circle")?.withRenderingMode(.alwaysTemplate)
        // Change the tint color of the image if complete 
        completedImageView.tintColor = task.isComplete ? .systemBlue : .tertiaryLabel
    }
}

