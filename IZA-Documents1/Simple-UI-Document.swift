//
//  SimpleDocument.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit


//
protocol SimpleDocScheme : Codable {
    //
    init();
}

///
enum SimpleDocErrors: Error {
    //
    case wrongContents
    case decodingError
    case encodingError
    case contentsMissing
}

/**
  - obecne pojeti dokumentu nad zadanym schematem.
 
 - Parameters: Scheme - struktura definujici format dokumentu
 */
class SimpleUIDocument<Scheme:SimpleDocScheme>: UIDocument {
    //
    var loadedDocument: Scheme?
    
    //
    override func load(fromContents contents: Any, ofType typeName: String?) throws
    {
        guard let _data = contents as? Data else {
            //
            throw SimpleDocErrors.wrongContents
        }
        
        //
        guard let _ld = try? JSONDecoder().decode(Scheme.self, from: _data) else {
            //
            throw SimpleDocErrors.decodingError
        }
        
        //
        loadedDocument = _ld
    }
    
    //
    override func contents(forType typeName: String) throws -> Any {
        //
        guard let _ld = loadedDocument else {
            //
            throw SimpleDocErrors.contentsMissing
        }
        
        //
        guard let _enco = try? JSONEncoder().encode(_ld) else {
            //
            throw SimpleDocErrors.encodingError
        }
        
        //
        return _enco
    }
}


//
extension UIDocument {
    /// druh ulozeni dokumentu: create || update
    static func decideSaveOperation(url: URL) -> SaveOperation {
        //
        let _exists = FileManager.default.fileExists(atPath: url.path)
        
        //
        return (_exists) ? .forOverwriting : .forCreating
    }
}

