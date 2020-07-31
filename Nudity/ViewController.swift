//
//  ViewController.swift
//  Nudity
//
//  Created by Philipp Gabriel on 01.10.17.
//  Copyright © 2017 Philipp Gabriel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
        self.checkImage(image!)
    }
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!
    var imagePicker: ImagePicker!

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func checkImage(_ image: UIImage) {
        let model = Nudity()
        let size = CGSize(width: 224, height: 224)

        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        guard let result = try? model.prediction(data: buffer) else {
            fatalError("Prediction failed!")
        }

        let confidence = result.prob["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)

        imageView.image = image
        percentage.text = "\(result.classLabel) - \(converted) %"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
