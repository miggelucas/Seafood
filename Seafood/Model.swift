//
//  Model.swift
//  Seafood
//
//  Created by Lucas Migge de Barros on 18/01/23.
//

import Foundation
import UIKit
import Vision


struct Model {
    
    static func predict(for image : UIImage, completion: @escaping ([VNClassificationObservation]) -> Void) {
        
        DispatchQueue.main.async {
            guard let ciimage = CIImage(image: image) else {
                fatalError("Could convert to imasge to CIImage")
            }
            
            guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: .init()).model) else {
                fatalError("Failed to load coreML model")
            }
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Failed to processes image")
                }
                
                completion(results)
            }
            
            let handler = VNImageRequestHandler(ciImage: ciimage)
            
            do {
                try handler.perform([request])
            } catch {
                print("failed to make request \(error.localizedDescription)")
            }
        }
    }
    
    static func getNamesAndPrecision(for itens: [VNClassificationObservation]) -> [Prediction] {
        let filteredItens = itens.filter { item in
            !item.confidence.isLessThanOrEqualTo(0.01)
            
        }
        
        return filteredItens.map { item in
            var roundedConfidence : Double {
                round(1000 * Double(item.confidence) / 1000)
            }
            
            return Prediction(name: item.identifier,
                              confidence: Double(item.confidence))
            
        }
    }
    
    
}
