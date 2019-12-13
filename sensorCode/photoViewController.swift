//
//  photoViewController.swift
//  talkCode
//
//  Created by localadmin on 22.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit

class photoViewController: UIViewController {

  @IBOutlet weak var photoImageView: UIImageView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = globalImage
        photoImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoViewController.tapFunction(sender:)))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
      dismiss(animated: true, completion: nil)
    }
}
