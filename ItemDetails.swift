//
//  ItemDetails.swift
//  wypozyczalnia
//
//  Created by Mac2 on 16/05/2022.
//

import SwiftUI

struct RentView:View{
    @Environment(\.presentationMode) var presentationMode
    @Binding var reservation:Reservation
    var item:Item
    @State var dateRozp = Date()
    @State var dateZak = Date()
    @State var docType = "dowod osobisty"
    var docTypes = ["dowod osobisty","paszport"]
    @State var docNumber = ""
    @State var formIsOk = false
    @Binding var isActive:Bool
    
    var body: some View{
        VStack{
            Text("Reserve your item").frame(maxWidth:.infinity)
                .font(.largeTitle)
                .padding(.bottom)
            Spacer()
            DatePicker("Data rozpoczecia", selection: $dateRozp,in:Date()...,displayedComponents:[.date]).padding(.bottom)
            DatePicker("Data zakonczenia", selection: $dateZak,in:self.dateRozp...,displayedComponents:[.date])
                .padding(.bottom)
            VStack{
                Text("Typ dokumentu").font(.title3)
                Picker(selection:$docType,label:Text("Typ dokumentu")){
                    ForEach(docTypes,id:\.self){
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
            }.padding(.bottom)
                .opacity(self.reservation.items.isEmpty ? 1 : 0)
            Group{
                Text("Numer dokumentu").font(.title3)
                TextField("Numer", text: $docNumber).onChange(of: self.docNumber, perform: { _ in
                    if(!self.docNumber.isEmpty){
                        self.formIsOk = true
                    }
                    else{
                        self.formIsOk = false
                    }
                })
                .padding(.bottom)
                .multilineTextAlignment(.center)
                
            }.opacity(self.reservation.items.isEmpty ? 1 : 0)
            
            
                Button(action: {
                    if(self.reservation.items.isEmpty){
                        self.reservation.beginDate = self.dateRozp
                        self.reservation.endDate = self.dateZak
                        self.reservation.docType = self.docType
                        self.reservation.docNumber = self.docNumber
                    }
                    self.reservation.items
                        .append(self.item)
                    self.isActive = false
                    print(self.reservation)
                }, label: {
                    Text("Reserve")
                        .font(Font.system(size:22))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color(red:0.94,green:0.9,blue:0.84)))
                        .foregroundColor(Color.black)
                        .opacity(self.formIsOk ? 1 : 0).clipShape(Capsule())
                }).opacity(self.reservation.items.isEmpty ? 1 : 0)
            Button(action: {
                self.reservation.items
                    .append(self.item)
                self.isActive = false
            }, label: {
                Text("Add to cart")
                    .font(Font.system(size:22))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color(red:0.94,green:0.9,blue:0.84)))
                    .foregroundColor(Color.black)
                    .clipShape(Capsule())
            }).opacity(self.reservation.items.isEmpty ? 0 : 1)
            Spacer()
        }.padding()
        
    }
}
struct ItemDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    var item:Item
    @State var showSheet = false
    @Binding var reservation:Reservation
    @State var showConfirmation = false
    var body: some View {
        ZStack{
            Rectangle().frame(maxWidth:.infinity,maxHeight: .infinity)
                .foregroundColor(Color.white)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.width > 0 {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                       
                                    }))
            VStack{
                Text(item.name)
                Text(String(item.price))
                    .padding(.bottom)
                Button(action: {
                    if(self.reservation.items.isEmpty){
                        self.showSheet.toggle()
                    }
                    else{
                        self.reservation.items.append(item)
                        self.showConfirmation.toggle()
                    }
                    
                }, label: {
                    Text(self.reservation.items.isEmpty ? "Rent" : "Add")
                        .font(Font.system(size:22))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color(red:0.94,green:0.9,blue:0.84)))
                        .foregroundColor(Color.black)
                        .clipShape(Capsule())
                })
            }.navigationBarTitle(item.name,displayMode: .large)
            .sheet(isPresented: $showSheet){
                RentView(reservation:$reservation, item:item,isActive:$showSheet)
                    
            }
            .alert(isPresented: $showConfirmation){
                Alert(title: Text("Added to cart"), message: Text("Item was added to your cart"), dismissButton: .default(Text("OK")))
            }        }
        
    }
}

struct ItemDetails_Previews: PreviewProvider {
    static var item = Item(id: UUID(), name: "", price: 0.0, image: "")
    static var previews: some View {
        ItemDetails(item:item,reservation:.constant(Reservation(beginDate: Date(), endDate: Date(), items: [],docType: "",docNumber: "")))
    }
}
