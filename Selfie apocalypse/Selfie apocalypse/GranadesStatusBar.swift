//
//  GranadesStatusBar.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/2/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

@IBDesignable class GranadesStatusBar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var thirdGranade: UIImageView!
    
    @IBOutlet weak var secondGranade: UIImageView!
    
    @IBOutlet weak var firstGranade: UIImageView!
    
    var view:UIView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GranadesStatusBar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        view.frame = bounds
//        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
//        view.sizeToFit()
//        view.setNeedsUpdateConstraints()	
        self.addSubview(view);
    }
    
     }
