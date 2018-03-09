//
//  ViewController.swift
//  FaceRecognition
//
//  Created by 小西夏穂 on 2018/03/08.
//  Copyright © 2018年 小西夏穂. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var nanaImageView: UIImageView!
    @IBOutlet weak var nanaTextView: UITextView!
    
    @IBAction func `import`(_ sender: Any) {
        //create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //display the image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage]as? UIImage
        {
            nanaImageView.image = image
        }
        
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect(){
        // Get image from image view
        let nanaImage = CIImage(image: nanaImageView.image!)!
        
        //Set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: nanaImage, options: [CIDetectorSmile:true])
        
        if !faces!.isEmpty{
            for face in faces as! [CIFaceFeature]
            {
                let moutShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                let isSmiling = "\nPerson is smiling: \(face.hasSmile)"
                var bothEyesShowing = "\nBoth eyes showing: true"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition{
                    bothEyesShowing = "\nBoth eyes showing: false"
                }
                
                //Degree of suspiciousness
                let array = ["Low", "Medium", "High", "Very high"]
                var suspectDegree = 0
                
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyesShowing.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                
                let suspectText = "\nSuspiciousness: \(array[suspectDegree])"
                
                nanaTextView.text = " \(suspectText) \n\(moutShowing) \(isSmiling) \(bothEyesShowing)"
            }
        }
        else
        {
            nanaTextView.text = "No faces found"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

