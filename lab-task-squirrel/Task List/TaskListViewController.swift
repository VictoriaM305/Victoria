//
//  TaskListViewController.swift
//  lab-task-squirrel
//
//  Created by Victoria Mckinnie on 09/13/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var tasks = [Task]() {
        didSet {
            emptyStateLabel.isHidden = !tasks.isEmpty
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMockTasks()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func loadMockTasks() {
        // Load or create some mock tasks
        tasks = Task.mockedTasks
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        performSegue(withIdentifier: "ShowTaskDetail", sender: task) // Check "ShowTaskDetail" is the correct identifier
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetail", // identifier matches
           let detailVC = segue.destination as? TaskDetailViewController,
           let task = sender as? Task {
            detailVC.task = task
        }
    }
}
