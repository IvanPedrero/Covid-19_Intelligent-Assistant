//
//  LoadingAnimationViewController.swift
//  Coronavirus Tracker
//
//  Created by Ivan Pedrero on 02/08/20.
//  Copyright © 2020 Ivan Pedrero. All rights reserved.
//

import UIKit
import Lottie

class LoadingAnimationViewController: UIViewController {

    private var animationView: AnimationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoadingAnimation()
    }
    
    func startLoadingAnimation() {
      
      // 2. Start AnimationView with animation name (without extension)
      
      animationView = .init(name: "loading")
      
      animationView!.frame = view.bounds
      
      // 3. Set animation content mode
      
      animationView!.contentMode = .scaleAspectFit
      
      // 4. Set animation loop mode
      
      animationView!.loopMode = .loop
      
      // 5. Adjust animation speed
      animationView!.animationSpeed = 1.5
      
      view.addSubview(animationView!)
      
      // 6. Play animation
      
      animationView!.play()
      
    }
    
    public func stopLoadingAnimation(){
        animationView!.stop()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
