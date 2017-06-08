//
//  ViewController.swift
//  FlowerUp
//
//  Created by Suraj Pathak on 7/6/17.
//  Copyright © 2017 Suraj Pathak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Image", style: .plain, target: self, action: #selector(addImage(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
    
    func imageType(_ image: UIImage) -> String? {
        UIGraphicsBeginImageContext(image.size)
        guard let cgImage = resized(image).cgImage, let context = UIGraphicsGetCurrentContext() else { return nil }
        let model = GoogLeNetPlaces()
        let ciimage = CIImage(cgImage: cgImage, options: nil)
        let ciContext = CIContext(cgContext: context, options: nil)
        var nilBuffer: CVPixelBuffer? = nil
        let _ = CVPixelBufferCreate(kCFAllocatorDefault, cgImage.width, cgImage.height, kCVPixelFormatType_32ARGB, nil, &nilBuffer)
        ciContext.render(ciimage, to: nilBuffer!)
        let output = try? model.prediction(sceneImage: nilBuffer!).sceneLabel
        return output
    }
    
    func resized(_ image: UIImage, targetSize: CGSize = CGSize(width: 112, height: 112)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: targetSize))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            nameLabel.text = imageType(image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

