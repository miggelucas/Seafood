//
//  ContentViewModel.swift
//  Seafood
//
//  Created by Lucas Migge de Barros on 18/01/23.
//

import Foundation
import SwiftUI
import Vision

enum pickerMode: String, Identifiable, CaseIterable {
    case camera = "Camera"
    case photoLibrary = "Fotos"
    
    var id: Self { self }
}

class ContentViewModel: ObservableObject {
    
    enum State {
        case empty, loading, content
    }
    
    enum ActiveSheet: Identifiable {
        case imagePicker, settings
        
        var id: Int {
            hashValue
        }
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
    @Published var activeSheet: ActiveSheet?
    @Published var isLoading = false
    @Published var navigationTitle: String = ""
    @Published var inputImage: UIImage? {
        didSet {
            processImage(withImage: inputImage!)
        }
    }
    
    @Published var predictions: [Prediction] = []
    @Published var modeSelection: pickerMode = .camera
    
    var mode: UIImagePickerController.SourceType {
        if self.modeSelection == .camera {
            return .camera
        } else {
            return .photoLibrary
        }
    }
    
    func sheetDismissed() {
        activeSheet = nil
    }
    
    func captureImageTapped() {
        activeSheet = .imagePicker
    }
    
    func gearButtonTapped() {
        activeSheet = .settings
    }
    
    
    func processImage(withImage image: UIImage) {
        self.image = Image(uiImage: inputImage!)
        isLoading = true
        navigationTitle = "Loading ..."
        
        Model.predict(for: image) { results in
            
            self.predictions = Model.getNamesAndPrecision(for: results)
            
            self.isLoading = false
            self.navigationTitle = "Done"
        }
        
        
    }
    
}


