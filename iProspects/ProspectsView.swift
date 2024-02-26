//
//  ProspectsView.swift
//  iProspects
//
//  Created by A.f. Adib on 1/6/24.
//
import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    @StateObject var newprospects = newProspect()
    
    @EnvironmentObject var prospects : Prospects
    
    @State private var isShowingScanner = false
    
    var labelName = LabelName()
    
    enum Filtertype {
        case none, contacted, uncontacted
    }
    
    let filter : Filtertype
    
    
    var title : String {
        switch filter {
        case .none:
            return labelName.everyOne
        case .contacted:
            return labelName.contacted
        case .uncontacted:
            return labelName.uncontacted
        }
    }
    
    var filteredProspect : [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView{
            List {
                ForEach(filteredProspect) { prospect in
                    VStack(alignment : .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label(labelName.markUncont, systemImage: labelName.unconImg)
                                    .font(.headline)
                            }.tint(.green)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label(labelName.markCont, systemImage: labelName.contImg)
                                    .font(.headline)
                            }.tint(.blue)
                            
                            Button{
                                addNotification(for: prospect)
                            } label: {
                                Label (labelName.remind, systemImage: labelName.bell)
                            }.tint(.orange)
                        }
                    }
                }
            }
                .navigationTitle(title)
                .toolbar {
                    Button {
                       isShowingScanner = true
                        
                    } label: {
                        Label(labelName.scan, systemImage: labelName.qrCode)
                            .font(.title)
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "\(newprospects.name)\n\(newprospects.emailAddress)", completion: handleScan)
                }

        }
    }
    
    func handleScan(result : Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
            
        case .failure(let error):
            print("Scanning error\(error)")
        }
    }
    
    func addNotification(for prospect : Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                        
                    } else {
                        print("error")
                    }
                }
            }
        }
    }
    
   
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView( filter: .none)
            .environmentObject(Prospects())
    }
}
