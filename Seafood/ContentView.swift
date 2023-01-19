//
//  ContentView.swift
//  Seafood
//
//  Created by Lucas Migge de Barros on 13/01/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .content:
                    List {
                        viewModel.image!
                            .resizable()
                            .scaledToFit()
                        ForEach(viewModel.predictions, id: \.self) { prediction in
                            HStack {
                                Text(prediction.name)
                                Spacer()
                                Text(String(format: "%.3f", prediction.confidence))
                            }
                            
                        }
                    }
                    
                case .empty:
                    VStack(alignment: .center) {
                        Text("Sem dados ainda")
                    }
                    
                case .loading:
                    VStack(alignment: .center) {
                        viewModel.image!
                            .resizable()
                            .scaledToFill()
                            .overlay(alignment: .center) {
                                ProgressView()
                            }
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $viewModel.showingImagePicker, onDismiss: viewModel.sheetdismissed) {
                ImagePicker(image: $viewModel.inputImage)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingImagePicker.toggle()
                    } label: {
                        Image(systemName: "camera")
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.gearButtonTapped()
                        
                    } label: {
                        Image(systemName: "gearshape.2")
                    }
                }
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


