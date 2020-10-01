//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Ping Yun on 10/1/20.
//

import SwiftUI

struct CheckoutView: View {
    //Order observed object property
    @ObservedObject var order: Order
    //stores alert message
    @State private var confirmationMessage = ""
    //stores whether or not alert is visible
    @State private var showingConfirmation = false
    
    var body: some View {
        //GeometryReader to make sure cupcake image is sized correctly
        GeometryReader {
            geo in
            ScrollView {
                VStack {
                    //cupcake image
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    //cost text
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    //button to place order
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        
        //alert() modifier to watch showingConfirmation boolean and show alert as soon as it is true
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    //method that is called from place order button
    func placeOrder() {
        //converts current order object into JSON data that can be sent
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
            
        //website automatically sends back any data we send it
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        //creates URLRequest
        var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //configures URLRequest to send JSON data using HTTP method POST
        request.httpMethod = "POST"
        //attaches data
        request.httpBody = encoded
        
        //makes network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            //reads the result our request
            guard let data = data else {
                //if something goes wrong, prints message and returns
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            //decodes data that came back
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                //uses data to set confirmation message
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                //sets showingConfirmation to true so alert appear
                self.showingConfirmation = true
            } else {
                //if decoding fails, prints error message 
                print("Invalid response from sever")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
            .previewDevice("iPhone 11")
    }
}
