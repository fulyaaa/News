//
//  SettingsViewController.swift
//  News
//
//  Created by fulya akan on 23.06.2026.
//
import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let sections = ["Appearance", "Notifications", "About"]
    private let rows = [["App Theme"], ["Notification"], ["Rate Us", "Privacy Policy", "Terms of Use"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func themeSwitched(_ sender: UISegmentedControl) {
        let style: UIUserInterfaceStyle = sender.selectedSegmentIndex == 0 ? .light : .dark
        view.window?.overrideUserInterfaceStyle = style
    }
    
    @objc private func notificationSwitched(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if !granted {
                        sender.setOn(false, animated: true)
                    }
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = rows[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = title
        cell.accessoryType = .none
        cell.accessoryView = nil
        
        switch indexPath.section {
        case 0:
            let segmented = UISegmentedControl(items: ["Light", "Dark"])
            segmented.selectedSegmentIndex = (traitCollection.userInterfaceStyle == .dark) ? 1 : 0
            segmented.addTarget(self, action: #selector(themeSwitched(_:)), for: .valueChanged)
            cell.accessoryView = segmented
            cell.selectionStyle = .none
            
        case 1:
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(notificationSwitched(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none
            
        case 2:
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2 else { return }
        
        switch indexPath.row {
        case 0:
            if let url = URL(string: "https://apps.apple.com/app/id6446901002") {
                UIApplication.shared.open(url)
            }
        case 1:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        case 2:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
}
