//
//  ContentViewModel.swift
//  Seafood
//
//  Created by Lucas Migge de Barros on 18/01/23.
//

import Foundation
import SwiftUI
import Vision


class ContentViewModel: ObservableObject {
    
    enum State {
        case empty, loading, content
    }
    
    var state : State {
        guard let _ = image else { return .empty }
        if isLoading {
            return .loading
        } else {
            return .content
        }
    }
    
    @Published var image : Image?
    @Published var showingImagePicker = false
    @Published var isLoading = false
    @Published var inputImage: UIImage?
    @Published var navigationTitle: String = ""
    @Published var predictions: [Prediction] = []

    
    
    func sheetdismissed() {
        guard let inputImage = inputImage else { return }
        self.image = Image(uiImage: inputImage)
    }
    
    func gearButtonTapped() {
        navigationTitle = "Loading..."
        if let safeImage = inputImage {
            processImage(withImage: safeImage)
        }
    }

    
    func processImage(withImage image: UIImage) {
        self.isLoading = true
        
        Model.predict(for: image) { results in
            
            self.predictions = Model.getNamesAndPrecision(for: results)

            self.isLoading = false
            self.navigationTitle = "Done"
        }
        
        
    }
    
}
