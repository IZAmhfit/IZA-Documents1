//
//  CreateNewDocumentDialog.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// Pracovni data pro CreateNewDocumentDialog
class CreateNewDocumentDialogModel: ObservableObject {
    // ovladac jednoho adresare
    // poskytuje zakladni URL
    let dirModel: DirectoryContentModel
    
    // vysledky analyzy zadaneho jmena ve forme kodu
    // a zpravy pro uzivatele
    enum NameEvaluation : String {
        //
        case ok = "OK"
        case noway = "Nelze vytvořit"
        case empty = "Prázdné"
        case existing = "Už existuje"
        case tooshort = "Příliš krátké"
    }
    
    // analyza vhodnosti daneho jmena pro dokument
    func evaluate(fileName: String) -> NameEvaluation {
        // ...
        if fileName.isEmpty { return .empty }
        if fileName.count < 3 { return .tooshort }
        
        // pripadne kompletni URL souboru by bylo
        guard let _wouldbe = dirModel.url(forFilename: fileName) else {
            //
            return .noway
        }
        
        // pokud uz existuje, pak ...
        if _wouldbe.fileExists {
            //
            return .existing
        }
        
        // nazev souboru je ok, dokument s timto nazvem lze vytvorit
        return .ok
    }
    
    // ridici stavova promenna tohoto View, jeho viditelnost
    @Published var sheetON = false
    
    // editovany nazev dokumentu a vysledek analyzy nazvu
    @Published var fileName: String = ""
    @Published var nameEvaluation: NameEvaluation = .empty
    
    // potencial seg-faultu, davam s __, pouze pro poucene pouziti
    var __url: URL { dirModel.url(forFilename: fileName)! }
    
    //
    var _storage = Set<AnyCancellable>()
    
    //
    init(inDir: DirectoryContentModel) {
        //
        self.dirModel = inDir
        
        //
        $fileName
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            // provedeni analyzy
            .map { self.evaluate(fileName: $0) }
            // export do property
            .assign(to: \.nameEvaluation, on: self)
            // ukladam si referenci na subscribera
            .store(in: &_storage)
    }
}

// Dialogove okno pro zadani platneho nazvu pro novy dokument
struct CreateNewDocumentDialog: View {
    //
    @ObservedObject var model: CreateNewDocumentDialogModel
    
    //
    func addAction() {
        // zichr je zichr
        if model.nameEvaluation == .ok {
            //
            model.dirModel.create(newDocument: model.__url)
        }
        
        //
        model.sheetON = false
    }
    
    //
    var body: some View {
        //
        Form {
            //
            Section(header: Text("Zadejte nové jméno")) {
                //
                myTextField("nějaké vkusné jméno", text: $model.fileName)
            }
            
            //
            Section(header: Text("Status: \(model.nameEvaluation.rawValue)")) {
                //
                Button("OK") { self.addAction() }
                    // tlacitko se povoli az...
                    .disabled(model.nameEvaluation != .ok)
            }
        }
    }
}

