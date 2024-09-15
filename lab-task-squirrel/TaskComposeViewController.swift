//
//  TaskComposeViewController.swift
//  lab-task-squirrel
//
//  Created by Victoria mckinnie on 09/13/24
//


import UIKit

class TaskComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!

    var onComposeTask: ((Task) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // setting default values in place
    }

    // Done button may be pressed to display action
    @IBAction func didTapDoneButton(_ sender: Any) {
        
        guard let title = titleField.text,
              let description = descriptionField.text,
              !title.isEmpty,
              !description.isEmpty else {
            presentEmptyFieldsAlert()// Display alerts if failed
            return
        }

        
        let task = Task(title: title, description: description)
        onComposeTask?(task)
        dismiss(animated: true) // remove the view controller after new task is created
    }

    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true) // remove the view controller after new task is created
    }

    // Presents an alert when either title or description fields are empty.
    private func presentEmptyFieldsAlert() {
        let alertController = UIAlertController(
            title: "Oops...",
            message: "Both title and description fields must be filled out.",
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true) // Display the alert to the user.
    }
}
