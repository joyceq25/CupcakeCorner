//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Ping Yun on 10/1/20.
//

import SwiftUI

struct AddressView: View {
    //order observed object property
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            //section with text fields bound to properties for user to enter delivery details 
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            //section that creates NavigationLink that points to an a CheckoutView, passing in the current order object
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            //disables section if hasValidAddress is false 
            .disabled(order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
            .previewDevice("iPhone 11")
    }
}
