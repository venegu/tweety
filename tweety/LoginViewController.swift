//
//  LoginViewController.swift
//  tweety
//
//  Created by Gale on 2/19/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gradient
        let color1 = UIColor(red: 42.0/255, green: 163.0/255, blue: 239.0/255, alpha: 1.0)
        let color2 = UIColor(red: 88.0/255, green: 178.0/255, blue: 235.0/255, alpha: 1.0)
        let color3 = UIColor(red: 141.0/255, green: 192.0/255, blue: 231.0/255, alpha: 1.0)
        let color4 = UIColor(red: 224.0/255, green: 226.0/255, blue: 228.0/255, alpha: 1.0)
        
        let gradientColor: [CGColor] = [color1.CGColor, color2.CGColor, color3.CGColor, color4.CGColor]
        let gradientLocations: [Float] = [0.0, 0.25, 0.75, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.login({ () -> () in
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        }
        // Clearing previous sessions - do this b/c of BDBO bug
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
