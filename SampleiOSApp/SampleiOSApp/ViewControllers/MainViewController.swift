//
//  ViewController.swift
//  SampleiOSApp
//
//  Created by hgangula on 14/02/23.
//

import UIKit
import AuthenticationServices

class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func downloadBtnClick(_ sender: UIButton) {
    let url = URL(string: "https://sample-videos.com/img/Sample-jpg-image-30mb.jpg")
    guard let url = url else { return }
    DownloadManager.shared.startDownload(url: url)
  }
}
