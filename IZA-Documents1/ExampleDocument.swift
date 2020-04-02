//
//  ExampleDocument.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation



//
struct ExampleDocScheme : SimpleDocScheme {
    //
    var nazev: String = "Novy dokument"
    var dateCreated: Date = Date()
    
    //
    var notes: [String] = []
}

