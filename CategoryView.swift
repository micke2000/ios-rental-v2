//
//  CategoryView.swift
//  wypozyczalnia
//
//  Created by Mac2 on 16/05/2022.
//

import SwiftUI

struct CategoryView: View {
    @Binding var reservation:Reservation
    @Binding var category:String
    @Binding var items:[Item]
    @State var isActive = false
    @State var activeItem = Item(name:"",price:0.0, image: "")
    var body: some View {
            VStack{
                Text("Choose a "+self.category)
                List(items){
                    item in NavigationLink(destination:ItemDetails(item:item,reservation:$reservation)){
                                HStack{
                                Text("Model: " + item.name)
                                    Spacer()
                                Text("Price:  " + String(item.price))
                            }
                            
                            
                        }
                    
                }
            }.navigationTitle(category)
            
            
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(reservation: .constant(Reservation(beginDate: Date(), endDate: Date(), items: [],docType: "",docNumber: "")), category:.constant("test"),items: .constant([Item(name: ".", price: 0.0, image: ".")]))
    }
}
