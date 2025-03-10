//
//  ViewController.swift
//  Mantis
//
//  Created by Yingtao Guo on 10/19/18.
//  Copyright © 2018 Echo Studio. All rights reserved.
//

import UIKit
import Mantis

class ViewController: UIViewController {
    var image = UIImage(named: "sunflower.jpg")
    var transformation: Transformation?
    
    @IBOutlet weak var croppedImageView: UIImageView!
    var imagePicker: ImagePicker!
    @IBOutlet weak var cropShapesButton: UIButton!
    
    private func createConfigWithPresetTransformation() -> Config {
        var config = Mantis.Config()
        
        if let transformation = transformation {
            config.cropViewConfig.presetTransformationType = .presetInfo(info: transformation)
        }

        return config
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func getImageFromAlbum(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
        
    @IBAction func normalPresent(_ sender: Any) {
        guard let image = image else {
            return
        }        
        var config = createConfigWithPresetTransformation()
        config.cropMode = .async
        
        let indicatorFrame = CGRect(origin: .zero, size: config.cropViewConfig.cropActivityIndicatorSize)
        config.cropViewConfig.cropActivityIndicator = CustomWaitingIndicator(frame: indicatorFrame)
        config.cropToolbarConfig.toolbarButtonOptions = .all
        
        if let transformation = transformation {
            config.cropViewConfig.presetTransformationType = .presetInfo(info: transformation)
        }
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: cropViewController)
        cropViewController.title = "Demo"
        present(navigationController, animated: true)
    }

    @IBAction func customViewController(_ sender: Any) {
        guard let image = image else {
            return
        }

        var config = Mantis.Config()
        config.cropMode = .async
        config.cropViewConfig.showAttachedRotationControlView = false
        config.showAttachedCropToolbar = false
        let cropViewController: CustomViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: cropViewController)
        present(navigationController, animated: true)
    }
    
    @IBAction func presentWithPresetTransformation(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
                
        let transform = Transformation(offset: CGPoint(x: 169, y: 152),
                                       rotation: -0.46043267846107483,
                                       scale: 2.129973210831677,
                                       isManuallyZoomed: true,
                                       initialMaskFrame: CGRect(x: 14.0, y: 33, width: 402, height: 603),
                                       maskFrame: CGRect(x: 67.90047201716507, y: 14.0, width: 294.19905596566986, height: 641.0),
                                       cropWorkbenchViewBounds: CGRect(x: 169,
                                                                y: 152,
                                                                width: 548.380489739444,
                                                                height: 704.9696330065433),
                                       horizontallyFlipped: true,
                                       verticallyFlipped: false)
        
        config.cropToolbarConfig.toolbarButtonOptions = .all
        config.cropViewConfig.presetTransformationType = .presetInfo(info: transform)
        config.cropViewConfig.builtInRotationControlViewType = .slideDial()
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func hideRotationDialPresent(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.showAttachedCropToolbar = false
        config.cropViewConfig.showAttachedRotationControlView = false
        config.cropViewConfig.minimumZoomScale = 2.0
        config.cropViewConfig.maximumZoomScale = 10.0
        
        let cropToolbar = MyNavigationCropToolbar(frame: .zero)
        let cropViewController = Mantis.cropViewController(image: image, config: config, cropToolbar: cropToolbar)
        cropViewController.delegate = self
        cropViewController.title = "Change Profile Picture"
        let navigationController = UINavigationController(rootViewController: cropViewController)
                
        cropToolbar.cropViewController = cropViewController
        
        present(navigationController, animated: true)
    }
    
    @IBAction func alwayUserOnPresetRatioPresent(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        let config = Mantis.Config()
        
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = self
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 16.0 / 9.0)
        present(cropViewController, animated: true)
    }
        
    @IBAction func customizedCropToolbarButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        var config = Mantis.Config()
        config.cropToolbarConfig = CropToolbarConfig()
        config.cropToolbarConfig.backgroundColor = .red
        config.cropToolbarConfig.foregroundColor = .white
        
        let cropToolbar = CustomizedCropToolbar(frame: .zero)
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config,
                                                           cropToolbar: cropToolbar)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func customizedCropToolbarWithoutListButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        var config = Mantis.Config()
        
        config.cropToolbarConfig.heightForVerticalOrientation = 160
        config.cropToolbarConfig.widthForHorizontalOrientation = 80
        
        let cropToolbar = CustomizedCropToolbarWithoutList(frame: .zero)
        
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config,
                                                           cropToolbar: cropToolbar)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func clockwiseRotationButtonTouched(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.cropToolbarConfig.toolbarButtonOptions = .all
        config.cropToolbarConfig.backgroundColor = .white
        config.cropToolbarConfig.foregroundColor = .gray
        config.cropToolbarConfig.ratioCandidatesShowType = .alwaysShowRatioList
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 2.0 / 1.0)
        config.cropViewConfig.builtInRotationControlViewType = .slideDial()
                
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    @IBAction func cropShapes(_ sender: Any) {
        showCropShapeList()
    }
    
    @IBAction func darkBackgroundEffect(_ sender: Any) {
        presentWith(backgroundEffect: .dark)
    }
    
    @IBAction func lightBackgroundEffect(_ sender: Any) {
        presentWith(backgroundEffect: .light)
    }
    
    @IBAction func customColorBackgroundEffect(_ sender: Any) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.cropViewConfig.backgroundColor = .yellow
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)

    }
    
    typealias CropShapeItem = (type: Mantis.CropShapeType, title: String)
    
    let cropShapeList: [CropShapeItem] = [
        (.rect, "Rect"),
        (.square, "Square"),
        (.ellipse(), "Ellipse"),
        (.circle(), "Circle"),
        (.polygon(sides: 5), "pentagon"),
        (.polygon(sides: 6), "hexagon"),
        (.roundedRect(radiusToShortSide: 0.1), "Rounded rectangle"),
        (.diamond(), "Diamond"),
        (.heart(), "Heart"),
        (.path(points: [CGPoint(x: 0.5, y: 0),
                        CGPoint(x: 0.6, y: 0.3),
                        CGPoint(x: 1, y: 0.5),
                        CGPoint(x: 0.6, y: 0.8),
                        CGPoint(x: 0.5, y: 1),
                        CGPoint(x: 0.5, y: 0.7),
                        CGPoint(x: 0, y: 0.5)]), "Arbitrary path")
    ]
    
    private func showCropShapeList() {
        guard let image = image else {
            return
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for item in cropShapeList {
            let action = UIAlertAction(title: item.title, style: .default) {[weak self] _ in
                guard let self = self else {return}
                var config = Mantis.Config()
                config.cropViewConfig.cropShapeType = item.type
                config.cropViewConfig.cropBorderWidth = 40
                config.cropViewConfig.cropBorderColor = .red
                
                let cropViewController = Mantis.cropViewController(image: image, config: config)
                cropViewController.modalPresentationStyle = .fullScreen
                cropViewController.delegate = self
                self.present(cropViewController, animated: true)
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.handlePopupInBigScreenIfNeeded(sourceView: cropShapesButton)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func presentWith(backgroundEffect effect: CropMaskVisualEffectType) {
        guard let image = image else {
            return
        }
        
        var config = Mantis.Config()
        config.cropViewConfig.cropMaskVisualEffectType = effect
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let embeddedCropViewController = navigationController.viewControllers.first as? EmbeddedCropViewController {
            embeddedCropViewController.image = image
            embeddedCropViewController.didGetCroppedImage = {[weak self] image in
                self?.croppedImageView.image = image
                self?.dismiss(animated: true)
            }
        }
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                   cropped: UIImage,
                                   transformation: Transformation,
                                   cropInfo: CropInfo) {
        print("transformation is \(transformation)")
        print("cropInfo is \(cropInfo)")
        croppedImageView.image = cropped
        self.transformation = transformation
        dismiss(animated: true)
    }
}

extension ViewController: CropViewControllerDelegate {
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didBecomeResettable resettable: Bool) {
        print("Is resettable: \(resettable)")
    }
}

extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.image = image
        croppedImageView.image = image
    }
}
