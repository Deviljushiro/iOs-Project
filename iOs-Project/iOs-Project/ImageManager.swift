//
//  ImageManager.swift
//  iOs-Project
//
//  Created by JeanMi on 26/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

extension UIImageView {
    
    // MARK: - Image layout

    /// Give the image a circle form
    ///
    /// - Parameter anyImage: the target image
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
    }
}
