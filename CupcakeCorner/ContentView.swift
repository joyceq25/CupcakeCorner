//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ping Yun on 10/1/20.
//

import SwiftUI

struct ContentView: View {
    //creates instance of Order
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                //section for cupcake type and quantity
                Section {
                    //picker letting users choose from types of cakes
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    //stepper with range 3-20 to choose amount of cakes
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                //section with three toggle switches bound to specialRequestEnabled, extraFrosting, addSprinkles
                Section {
                    Toggle(isOn: $order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    //second and third switches should only be visible when first one is enabled 
                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                //section that creates NavigationLink that points to an AddressView, passing in the current order object 
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            //sets title of navigation bar
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
