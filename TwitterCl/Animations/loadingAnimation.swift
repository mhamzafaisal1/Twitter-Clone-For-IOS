//
//  loadingAnimation.swift
//  TwitterCl
//
//  Created by Abdullah on 26/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

extension UIView {
    func showBlurLoader() {
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
    }

    func removeBluerLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}


class BlurLoader: UIView {
    
    var value: CGFloat = 0.0
    var invert: Bool = false
    let logoView = UIImageView(image: UIImage(named: "blackLogo.png"))

    var blurEffectView: UIVisualEffectView?

    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        
        let view = blurEffectView.contentView
        view.addSubview(logoView)

        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleAnimation))
        displayLink.add(to: RunLoop.main, forMode: .default)
    }
    
    @objc func handleAnimation() {
        invert ? (value -= 1.5) : (value += 1.5)
        logoView.alpha = value/100
//        circle.backgroundColor = UIColor.red.withAlphaComponent(value/100)
        if value > 100 || value < 0 {
            invert = !invert
        }
        
    }
    
}
