//
//  ContentView.swift
//  SwiftDay6Basics
//
//  Created by Bibek Bhujel on 17/10/2024.
//

import SwiftUI


struct ContentView: View {
    @State private var showSheet = false

    var body: some View {
//        VStack {
//            Button("Show sheet") {
//                showSheet = true
//            }
//        }
//        .padding()
//        .sheet(isPresented: $showSheet, content: {
//            SecondView(name: "Bibek")
//        })
        NavigationStack {
//            VStack {
//                LearningDelete()
//            }
//            .toolbar {
//                EditButton()
//            }
            ArchieveAndUnarchieve()
            ArchieveAndUnarchieve()
        }
    }
}

struct UserView: View {
    @State var users: [User]
    var body: some View {
        List(users,id:\.userId) {
            user in
            HStack {
                Text(user.userName)
                Text("\(user.userId)")
            }
        }
    }
}

@Observable
class User {
    let userId: Int
    let userName: String
    init(userId: Int, userName: String) {
        self.userId = userId
        self.userName = userName
    }
    static let users = [User(userId: 1, userName: "bibek"), User(userId: 2, userName: "sanjina")]
}


// As soon as I change the structure to be class
// the code will no longer run because
// We had used @State in the first place
// to get rid of using mutating for the function that is changing the property.


// showing or hinding sheets
struct SecondView: View {
    let name:String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("hello \(name)")
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}










// deleting items using onDelete()
struct LearningDelete: View{
    // we can use onDelete method on ForEach only
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    var body: some View {
        List {
            ForEach(numbers, id: \.self) {
                Text("\($0)")
            }.onDelete(perform:removeRows)
            Button("Add Number") {
                numbers.append(currentNumber)
                currentNumber += 1
            }
        }
    }
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

// storing user settings with UserDefaults
struct UserSettingsUserDefaults: View {
    @State private var count = UserDefaults.standard.integer(forKey:"Tap")
    // Using @AppStorage wrapper around the userdefaults
    // easier
    @AppStorage("TapKey") private var isDarkMode = false
    
    var body: some View {
        VStack {
            Button("Increment Count") {
               count += 1
                isDarkMode = true
                UserDefaults.standard.set(count, forKey:"Tap")
            }
            Text("\(count)")
            Text("Another count: \(isDarkMode)")
        }
    }
}


// archiving swift objects with codable
// The use of codable protocol is to archieve and unarchieve data,
// archieve -> convert from object to plain text ( like JSON format )
// unarchieve -> vice versa

struct AnotherUser: Codable {
    let firstName:String
    let lastName:String
    static var user = AnotherUser(firstName: "bibek", lastName: "bhujel")
}
struct ArchieveAndUnarchieve: View {
    @State private var user = AnotherUser.user
    @State private var retrievedData: AnotherUser?
    var body: some View {
        VStack {
            Button("Add Person") {
                // first convert into text, i.e. json in this case
                addData()
                }
            }
        Button("Retrieve Person") {
            retrieveData()
        }
            Spacer()
        
        if let retrievedData = retrievedData{
            Text("My first name is \(retrievedData.firstName).")
            Text("My last name is \(retrievedData.lastName).")
        }
        }
    func addData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user) {
            UserDefaults.standard.set(data, forKey: "UserData")
       }
   }
    func retrieveData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "UserData") {
            if let decodedData = try? decoder.decode(AnotherUser.self,from:data) {
                retrievedData = decodedData
            }
        }
    }
}



#Preview {
    ContentView()
}
