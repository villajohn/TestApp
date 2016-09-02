//
//  Network.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Network Request
func makeRequest(server: String, metodo: String, params: AnyObject, completionHandler: ([NSDictionary]?, NSError?) -> ()) {
    let metodoURL = checkAlamoMethod(metodo)
    
    Alamofire.request(metodoURL, server, parameters: params as? [String: AnyObject])
        .responseJSON {
            response in
            switch response.result {
            case .Success(let value):
                let record = value as? NSArray
                var dictionaries = [NSDictionary]()
                if record != nil {
                    for row in record! {
                        dictionaries.append((row as? NSDictionary)!)
                    }
                }
                completionHandler(dictionaries, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
    }
}

func makeRequest_(server: String, metodo: String, params: AnyObject, completionHandler: (NSDictionary?, NSError?) -> ()) {
    let metodoURL = checkAlamoMethod(metodo)
    
    Alamofire.request(metodoURL, server, parameters: params as? [String: AnyObject])
        
        .responseString {
            response in
            switch response.result {
            case .Success(let value):
                print(value)
            case .Failure(let error):
                print(error)
            }
    }
}

func checkAlamoMethod(metodo: String) -> Alamofire.Method {
    var metodoURL : Alamofire.Method
    switch metodo {
    case "GET":
        metodoURL = .GET
    case "POST":
        metodoURL = .POST
    default:
        metodoURL = .GET
    }
    return metodoURL
}