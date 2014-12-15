//
//  ViewController.swift
//  iSouvenir
//
//  Created by m2sar on 26/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    private var mapVue : Mavue!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ecran = UIScreen.mainScreen()
        let rect = ecran.bounds
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        //Mavue : Map 
        mapVue = Mavue(frame: rect)
        mapVue.myController = self
        
        //Les add subView
        
        self.view = mapVue
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

