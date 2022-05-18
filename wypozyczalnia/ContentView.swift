//
//  ContentView.swift
//  wypozyczalnia
//
//  Created by Mac2 on 14/05/2022.
//

import SwiftUI
struct Item:Identifiable{
    var id = UUID()
    var name:String
    var price:Double
    var image:String
}
struct Reservation:Identifiable{
    var id = UUID()
    var beginDate:Date
    var endDate:Date
    var items:[Item]
    var docType:String
    var docNumber:String
}
struct ContentView: View {
    @State var currentReservation:Reservation = Reservation(beginDate: Date(), endDate: Date(), items: [],docType: "",docNumber: "")
    var body: some View {
        TabView{
            HomeView(reservation: $currentReservation)
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            Reservations()
                .tabItem {
                    Image(systemName: "clock")
                        Text("My Reservations")
                }
            CurrentReservation(reservation: $currentReservation)
                .tabItem{
                    Image(systemName: currentReservation.items.isEmpty ? "note" : "cart")
                    Text("Reservation Cart")
                }
        }
        
    }
}
struct Reservations: View {
    var body: some View {
        NavigationView{
            ZStack{
                Text("My Reservations")
                    .padding()
            }
            .navigationTitle(Text("My Reservations"))
        }
        
    }
}
struct CurrentReservation: View {
    @Binding var reservation:Reservation
    @State var dateFormatter = DateFormatter()
    @State var dataRozp = ""
    @State var dataZak = ""
    @State var duration:Int = 0
    @State var totalAmount = 0.0
    @State var showConfirmation = false
    @State var currentId = UUID()
    func setFormatter(){
        self.dateFormatter.dateStyle = .short
        self.dataRozp = dateFormatter.string(from: self.reservation.beginDate)
        self.dataZak =  dateFormatter.string(from: self.reservation.endDate)
        
        
    }
    func setTotalAmount(){
        self.totalAmount = 0.0
        self.duration = Int(((self.reservation.endDate.timeIntervalSinceReferenceDate - self.reservation.beginDate.timeIntervalSinceReferenceDate).rounded(.up) / 86400).rounded(.up))
        self.reservation.items.forEach{
            item in
            self.totalAmount += item.price * Double(self.duration)
        }
        
    }
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Text("Data rozpoczecia: " + self.dataRozp)
                Text("Data zakonczenia: " + self.dataZak)
                Text("Numer dokumentu: " + self.reservation.docNumber)
                List{
                    ForEach(self.reservation.items){
                    item in
                    HStack{
                    Text(item.name)
                        Spacer()
                    Text(String(item.price) + " per day")
                    }.onLongPressGesture(perform: {
                        self.showConfirmation.toggle()
                        self.currentId = item.id
                    })
                        
                    }
                }
                
                Button(action: {
                    self.reservation = Reservation(beginDate: Date(), endDate: Date(), items: [], docType: "", docNumber: "")
                }, label: {
                    Text("Delete")
                        .font(Font.system(size:22))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color(red:0.94,green:0.9,blue:0.84)))
                        .foregroundColor(Color.black)
                        .clipShape(Capsule())
                })
                Text("Calkowity koszt: " + String(self.totalAmount.rounded()))
                Spacer()
            }.opacity(self.reservation.items.isEmpty ? 0 : 1)
            .alert(isPresented: $showConfirmation){
                Alert(title: Text("Removing from cart"), message: Text("Na pewno chcesz usunac przedmiot?"), primaryButton: .destructive(Text("Delete"),action: {
                    self.reservation.items = self.reservation.items.filter{
                        $0.id != currentId
                    }
                    setTotalAmount()
                }) ,secondaryButton: .default(Text("Cancel"),action: {
                    
                }))
            }
            .navigationTitle("Reservation")
            .onAppear(){
                setFormatter()
                setTotalAmount()
                    
            }
        }
        
    }
}
struct HomeView: View {
    @Binding var reservation:Reservation
    @State var categories = ["Narty","Buty","Kije"]
    @State var category = "cos"
    @State var isActive = false
    @State var activeItems = [Item(name: "", price: 0.0, image: "")]
    
    @State var items = [
        "Narty":[
            Item(name: "Dlugie XXL 140", price: 43.23, image: "."),
                                        Item(name: "Krotkie M 120", price: 37.20, image: ".")],
        "Buty":[
            Item(name: "Ultra Buty", price: 33.23, image: "."),
                                        Item(name: "Slabe Buty", price: 35.20, image: ".")],
        "Kije":[
            Item(name: "Kije Samobije", price: 21.23, image: "."),
                                        Item(name: "Kije Niebije", price: 24.00, image: ".")]
    ]
    var body: some View {
        NavigationView{
            VStack{
                ForEach(categories,id:\.self){c in
                    
                    NavigationLink(destination:CategoryView(reservation:$reservation, category:$category, items:$activeItems),isActive:$isActive){
                            Button(action: {
                                self.category = c
                                self.activeItems = self.items[c,default: [Item(name: "", price: 0.0, image: "")]]
                                self.isActive = true
                            }, label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red:0.94,green:0.9,blue:0.84))
                                    .frame(width:200,height: 100)
                                Text(c.uppercased())
                                    .font(.system(size:22,weight:.bold))
                                    .foregroundColor(Color.black)
                            }.padding(.bottom)
                                
                            })
                        }
                            
                }
                
            }
            .navigationTitle("Categories")
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
