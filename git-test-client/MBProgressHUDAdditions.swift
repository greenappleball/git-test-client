//
//  MBProgressHUDAdditions.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/22/16.
//  Copyright © 2016 PI. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {

    static func showTextHUDInView(_ view: UIView, with text: String = "Loading...") -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true);
        hud.backgroundView.style = .blur
        hud.label.text = text
        hud.mode = .text
        return hud
    }


}
