//
//  ViewController.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/14/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var galleryButon: UIButton!
    
    @IBOutlet weak var cameraButon: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var picker:UIImagePickerController = UIImagePickerController()
    var mainimage = UIImage(named: "temp")
    let customColor = UIColor(red:218/255, green:247/255, blue:166/255, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        
        picker.delegate = self
        
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
        cameraButon.layer.cornerRadius = cameraButon.bounds.size.height*0.5
        galleryButon.layer.cornerRadius = galleryButon.bounds.size.height*0.5
        mainimage = mainimage?.rotateCameraImageToProperOrientation()
        mainImageView.image = mainimage
        
//        imageOrientation = mainimage?.imageOrientation
        
    }
    
    
    
    private func viewConfigure(){
        resetButton.layer.cornerRadius = resetButton.bounds.size.height*0.5
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = customColor
        
        galleryButon.layer.cornerRadius = galleryButon.bounds.size.height*0.5
        galleryButon.layer.borderWidth = 2
        galleryButon.layer.borderColor = customColor
        
        cameraButon.layer.cornerRadius = cameraButon.bounds.size.height*0.5
        cameraButon.layer.borderWidth = 2
        cameraButon.layer.borderColor = customColor
    }
    
    @IBAction func cameraButonAction(_ sender: Any) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func galleryButonAction(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        mainImageView.image = mainimage
    }
    
}

extension ViewController:UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            print("error")
            return
        }
        
        let newimage = image.rotateCameraImageToProperOrientation()
        mainimage = newimage
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = newimage
        dismiss(animated: true, completion: nil)
    }
     
}


extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! FilterCollectionViewCell
        cell.cellViewSet()
        
        let filter = AllCustomCIFilter.shared.filters[indexPath.item]
        cell.setlabelText(text: filter.rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllCustomCIFilter.shared.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterType = AllCustomCIFilter.shared.filters[indexPath.item]
        guard let filteredImage = AllCustomCIFilter.shared.applyCustomFilter(filterType: filterType, image: mainimage) else {return}
        mainImageView.image = filteredImage
        
//        guard let cgImage = filteredImage.cgImage else {return}
//        let newImage = UIImage(cgImage: cgImage, scale: filteredImage.scale, orientation: imageOrientation ?? .up)
//        mainImageView.image = filteredImage
    }
    
    
    
    
}

