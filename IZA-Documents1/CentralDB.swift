//
//  CentralDB.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit

//
class CentralDB {
    //
    static let shared = CentralDB()
    
    //
    var cloudMode: Bool = false
    
    //
    func checkCloudStatus() {
        //
        print("Cloud is ON=\(FileManager.cloudON)")
        
        //
        cloudMode = FileManager.cloudON
    }
    
    //
    func moveLocalDocumentsToCloud() {
        //
        
    }
}
