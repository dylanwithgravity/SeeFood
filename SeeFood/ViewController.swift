//
//  ViewController.swift
//  SeeFood
//
//  Created by Dylan Williamson on 7/30/18.
//  Copyright © 2018 Dylan Williamson. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userSelectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = userSelectedPhoto
            
            // if ciimage is nil, trigger else statement that gives error message
            guard let ciimage = CIImage(image: userSelectedPhoto) else {
                fatalError("Could not convert to a CIImage")
            }
            
            detect(image: ciimage)
       
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        // if model is nil, trigger else statement that gives error message
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Error, model is nil")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            //check first result from model
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
          try handler.perform([request])
        } catch {
            print(error)
        }
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

