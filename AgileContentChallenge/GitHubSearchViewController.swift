//
//  GitHubSearchViewController.swift
//  AgileContentChallenge
//
//  Created by Matheus Holanda on 23/10/17.
//  Copyright © 2017 NATI. All rights reserved.
//

import UIKit
import Alamofire

class GitHubSearchViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    var gitHubProfileService: GitHubProfileService!
    var repositories: [Repository] = []
    var user: User!
    
    let loading = UIActivityIndicatorView()
    let loadingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gitHubProfileService = GitHubProfileService(delegate: self)
    }
    
    // MARK: - Search Button Action
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if self.usernameTextField.text == "" {
            
            self.showAlert(message: "Digite um nome de usuário.")
        } else {
            
            if let username = self.usernameTextField.text {
                
                self.loadingViewSetup()
                self.loading.startAnimating()
                
                self.gitHubProfileService.getGitHubProfile(username: username)
            }
        }
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detalhePerfilController = segue.destination as? GitHubProfileViewController {
            
            detalhePerfilController.repositories = self.repositories
            detalhePerfilController.user = self.user
        }
    }
    
    // MARK: - Alert Controller 
    
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert:UIAlertAction) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Setup Loading View
    
    func loadingViewSetup() {
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 0.3)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        loading.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loading.activityIndicatorViewStyle = .whiteLarge
        loading.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
        loading.hidesWhenStopped = true
        
        loadingView.addSubview(loading)
        
        view.addSubview(loadingView)
    }
    
    func removeLoadingView() {
        
        self.loading.stopAnimating()
        self.loadingView.removeFromSuperview()
    }
}

 // MARK: - Requests

extension GitHubSearchViewController: GitHubProfileServiceDelegate {
    
    func getGitHubProfileSuccess(user: User) {
        
        self.user = user
        
        self.gitHubProfileService.getGitHubProfileRepos(username: self.user.username)
    }
    
    func getGitHubProfileRepoSuccess(repositories: [Repository]) {
        
        self.repositories = repositories
        
        self.removeLoadingView()
        
        self.performSegue(withIdentifier: "detalhePerfil", sender: nil)
    }
    
    func getGitHubProfileFailure(_ errorMessage: String) {
        
        self.removeLoadingView()
        
        self.showAlert(message: errorMessage)
    }
}
