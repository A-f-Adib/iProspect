//
//  ContentView.swift
//  iProspects
//
//  Created by A.f. Adib on 1/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var prospects = Prospects()
    var labelName = LabelName()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label(labelName.everyOne, systemImage: labelName.personImg )
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label(labelName.contacted, systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }.environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
