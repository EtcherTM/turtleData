//
//  ObservationViewController.swift
//  TurtleApp
//
//  Created by Olivia James on 8/15/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class ObservationViewController: UIViewController, UINavigationControllerDelegate  {

    var imagePicker: UIImagePickerController!

    enum ImageSource {
        case photoLibrary
        case camera
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

//    //MARK: - Take image
//    @IBAction func takePhoto(_ sender: UIButton) {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            selectImageFrom(.photoLibrary)
//            return
//        }
//        selectImageFrom(.camera)
//    }
//
//    func selectImageFrom(_ source: ImageSource){
////        imagePicker =  UIImagePickerController()
////        imagePicker.delegate = self
//        switch source {
//        case .camera:
//            imagePicker.sourceType = .camera
//        case .photoLibrary:
//            imagePicker.sourceType = .photoLibrary
//        }
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    //MARK: - Saving Image here
////    @IBAction func save(_ sender: AnyObject) {
////        guard let selectedImage = imageTake.image else {
////            print("Image not found!")
////            return
////        }
////        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
////    }
//
//    //MARK: - Add image to Library
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            // we got back an error!
//            showAlertWith(title: "Save error", message: error.localizedDescription)
//        } else {
//            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
//        }
//    }
//
//    func showAlertWith(title: String, message: String){
//        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
// }
//
// extension ViewController: UIImagePickerControllerDelegate{
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        imagePicker.dismiss(animated: true, completion: nil)
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            print("Image not found!")
//            return
//        }
//        imageTake.image = selectedImage
//    }
}
