//
//  GitHubProfileViewController.swift
//  AgileContentChallenge
//
//  Created by Matheus Holanda on 23/10/17.
//  Copyright © 2017 NATI. All rights reserved.
//

import UIKit

class GitHubProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var repositories: [Repository] = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.configureLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Configuration
    
    func configureTableView() {
        
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        
        if self.repositories.isEmpty {
            
            let noRepoLabel = UILabel(frame: self.tableView.bounds)

            noRepoLabel.numberOfLines = 0
            noRepoLabel.textAlignment = NSTextAlignment.center
            noRepoLabel.text = "Não há repositórios neste perfil."
            noRepoLabel.sizeToFit()
            
            self.tableView.backgroundView = noRepoLabel
        }
    }
    
    func configureLayout() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        
        if let avatarImageURL = URL(string: self.user.avatarImage) {
            
            if let imageData = try? Data(contentsOf: avatarImageURL) {
                
                self.avatarImageView.image = UIImage(data: imageData)
            }
        }
        
        self.usernameLabel.text = self.user.name
    }
}

// MARK: - UITableView DataSource

extension GitHubProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "infoIdentifier", for: indexPath)
        let repository = self.repositories[indexPath.row]
        
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = repository.language
        
        return cell
    }
}
