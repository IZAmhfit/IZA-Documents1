//
//  ContentView.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import SwiftUI

//
class Dosom  {
    //
    var kod: (()->())? = nil
    
    //
    func akce(kod: @escaping ()->()) {
        //
        self.kod = kod
    }
    
    //
    init(kod: (()->())? = nil) { self.kod = kod }
}

///
struct ContentView: View {    
    //
    var body: some View {
        //
        TabView {
            //
            DirectoryView(kind: .localDocuments).tag(0).tabItem { Text("Local") }
            DirectoryView(kind: .cloudDocuments).tag(1).tabItem { Text("Cloud") }
            Button("eeee") { self.akce() }.tag(2)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
