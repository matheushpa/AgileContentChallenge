//
//  RequestFactory.swift
//  AgileContentChallenge
//
//  Created by Matheus Holanda on 24/10/17.
//  Copyright © 2017 NATI. All rights reserved.
//

import Alamofire

let baseURL = "https://api.github.com/users/"

class RequestFactory {
    
    static func getGitHubProfileRepos(_ username: String) -> DataRequest {
        
        let url = "\(baseURL)\(username)/repos"

        return Alamofire.request(self.getSafeURL(url), method: .get)
    }
    
    static func getGitHubProfile(_ username: String) -> DataRequest {
        
        let url = "\(baseURL)\(username)"
        
        return Alamofire.request(self.getSafeURL(url), method: .get)
    }
    
    private static func getSafeURL(_ url: String) -> String {
        
        return url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
    }
}
