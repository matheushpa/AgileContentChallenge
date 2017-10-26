//
//  GitHubProfileService.swift
//  AgileContentChallenge
//
//  Created by Matheus Holanda on 24/10/17.
//  Copyright © 2017 NATI. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

protocol GitHubProfileServiceDelegate {
    
    func getGitHubProfileRepoSuccess(repositories: [Repository])
    func getGitHubProfileSuccess(user: User)
    
    func getGitHubProfileFailure(_ errorMessage: String)
}

class GitHubProfileService {
    
    var delegate: GitHubProfileServiceDelegate
    var getGitHubProfileRequest: Request?
    
    required init(delegate: GitHubProfileServiceDelegate) {
        
        self.delegate = delegate
    }
    
    func getGitHubProfile(username: String) {
        
        getGitHubProfileRequest?.cancel()
        
        getGitHubProfileRequest = RequestFactory.getGitHubProfile(username).validate().responseObject(completionHandler: { (response: DataResponse<User>) in
            
            switch response.result {
                
            case .success:
                
                if let user = response.result.value {
                    
                    self.delegate.getGitHubProfileSuccess(user: user)
                }
                
            case .failure:
                
                let errorMessage = self.errorHandler(response: response)
                
                self.delegate.getGitHubProfileFailure(errorMessage)
            }
        })
    }
    
    func getGitHubProfileRepos(username: String) {
        
        getGitHubProfileRequest?.cancel()
        
        getGitHubProfileRequest = RequestFactory.getGitHubProfileRepos(username).validate().responseArray(completionHandler: { (response: DataResponse<[Repository]>) in
        
            switch response.result {
                
            case .success:
                
                if let repositories = response.result.value {
                    
                    self.delegate.getGitHubProfileRepoSuccess(repositories: repositories)
                }
            
            case .failure:
                
                let errorMessage = self.errorHandler(response: response)
                
                self.delegate.getGitHubProfileFailure(errorMessage)
            }
        })
    }
    
    private func errorHandler<T: Any>(response: DataResponse<T>) -> String {
        
        if let httpResponse = response.response {
            
            if httpResponse.statusCode == 404 {
                
                return "Usuário não encontrado. Favor inserir outro nome."
            }
        } else {
            
            if let error = response.result.error as? URLError {
                
                if error.errorCode == -999 {
                    
                    print("Request cancelado!")
                }
                
                if error.errorCode == -1009 {
                    
                    return "Ocorreu um erro de rede. Verifique sua conexão com a Internet e tente novamente mais tarde."
                }
            }
        }
        
        return "Serviço não disponível."
    }
}
