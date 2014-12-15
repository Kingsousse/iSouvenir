//
//  Mavue.swift
//  iSouvenir
//
//  Created by m2sar on 26/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit
import AddressBookUI
import MobileCoreServices


class Mavue: UIView, UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate {
    
    
    
    var myController : UIViewController?
    
    private let terminal = UIDevice.currentDevice()
    private var map : MKMapView!
    private var locMngr : CLLocationManager!
    private var targetImg : UIImageView!
    private var mapType : UISegmentedControl!
    private var toolBar : UIToolbar!
    private var add , delete , refresh , smallSp , varSpace , book , photo , archive : UIBarButtonItem!
    private var epingle, position : UILabel!
    private var cameraMap : MKMapCamera!
    private var compteur : NSInteger!
    private var coordGenerale : CLLocationCoordinate2D!
    private var rect : CGRect
    private var typeMap : NSInteger!
    private var annot : Annotation!
    private var pop, pop2, pop3 : UIPopoverController!
    private var isPad : Bool!
    
    private var annotationSelected : MKAnnotation!
    
    //////////////////BOOK///////////////////
    
    private let abnavctrl = ABPeoplePickerNavigationController()
    
    
    /////////////////PHOTO//////////////////////
    private var  photoPicker = UIImagePickerController()
    private var  unePhoto = UIImageView()
    private var  dicoPhoto = NSMutableDictionary()


    override init(frame: CGRect) {
        
        let ecran = UIScreen.mainScreen()
        rect = ecran.bounds
        
      
        
        if (CLLocationManager.locationServicesEnabled()) {
            compteur = 0
            typeMap = 1
            annotationSelected = nil
            
            
            
            //Map
            map = MKMapView()
            map.scrollEnabled = true
            map.zoomEnabled = true
            coordGenerale = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            
            
            
            //MapCaméra
            
        
          
            
            //TargetButton
            targetImg = UIImageView(image: UIImage(named: "Target"))
      
            
            //MapType
            mapType = UISegmentedControl(items: ["3D","Carte","Satellite","Hybride"])
            mapType.selectedSegmentIndex = 1
            mapType.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            mapType.tintColor = UIColor.blackColor()
           
            
            //ToolsBar
            toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.Default

            
           
          
            
            epingle = UILabel()
            epingle.font = UIFont(name: epingle.font.fontName, size: 11)
            epingle.text = "Epingles..."
            
            position = UILabel()
            position.font = UIFont(name: position.font.fontName, size: 11)
            position.textAlignment = NSTextAlignment.Center
            position.text = ""
            
            
            //LocationManager
            locMngr = CLLocationManager()
       
            //Photos
            unePhoto.backgroundColor = UIColor.blackColor()
            unePhoto.hidden = true
            
            //terminal
            if(terminal.userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
                isPad = true
            }else{
                isPad = false
            }
            
            super.init(frame:frame)
           
            //localisation Manager
            locMngr.distanceFilter = 1.0
            locMngr.delegate = self
            locMngr.requestAlwaysAuthorization()
            
            map.delegate = self
            abnavctrl.delegate = self
            photoPicker.delegate = self
        
            
           
            //Action Target
            add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add , target: self, action: "ajouter:")
            delete = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash , target: self, action: "supprimer:")
            delete.enabled = false
            refresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh , target: self, action: "trouverMoi:")
            book = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks , target: self, action: "contactBook")
            book.enabled = false
            photo = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera , target: self, action: "prendrePhoto")
            photo.enabled = false
           
            archive = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize , target: self, action: "organizer")
            archive.enabled = false
            smallSp = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace , target: nil, action: nil)
            varSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace , target: nil, action: nil)
            
            toolBar.items = [add,smallSp,delete,varSpace,refresh,varSpace,book,smallSp,smallSp,photo,smallSp,archive]
            
            
            //Action Target
            mapType.addTarget(self, action: "changeCarte:", forControlEvents: UIControlEvents.ValueChanged)
            
            
            

            
            //SubView
            self.addSubview(map)
            self.addSubview(unePhoto)
            self.addSubview(targetImg)
            self.addSubview(mapType)
             self.addSubview(toolBar)
            self.addSubview(epingle)
            self.addSubview(position)
            
            
            drawRect(rect)
        
            
            photoPicker.delegate = self
            
            
            
        } else {
            var alert = UIAlertView()
            alert.addButtonWithTitle("OK")
            alert.title = "Erreur"
            alert.message = "Localisation désactivée"
            super.init(frame:frame)
            self.addSubview(alert)
            alert.show()

        }

    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        
        
        
        if(terminal.userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            //////IPAD////////
            
            
            if ((terminal.orientation == UIDeviceOrientation.Portrait) ) {
                ///portrait///////
                
                
                
                y = rect.size.height / 2
                x = 0
                unePhoto.frame = CGRectMake(x, y, rect.size.width, y)
                
                x = rect.size.width/2 - 340/2
                y =  28
                mapType.frame = CGRectMake(x, y, 340, 30)
                
                y = rect.size.height - 45
                x = rect.size.width
                epingle.frame = CGRectMake(x-10-60, y-3-17, 60, 17)
                position.frame = CGRectMake(0, y-3-17, rect.size.width - epingle.frame.width, 17)
                
                x = 0
                y = rect.size.height
                toolBar.frame = CGRectMake(x, y - toolBar.frame.size.height, rect.size.width, 44+19)
                
                if(!unePhoto.hidden) {
                    ///////Une photo afficher
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height/2)
                    x = rect.size.width/2
                    y = rect.size.height/4
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                } else {
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height)
                    x = rect.size.width/2
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                }
                
                
                
            } else {
                ///Paysage///////
                
                
                y = 0
                x = rect.size.width / 2
                unePhoto.frame = CGRectMake(x, y, x, rect.size.height)
                
                
                y = rect.size.height - 45
                x = rect.size.width
                epingle.frame = CGRectMake(x-10-60, y-3-17, 60, 17)
                position.frame = CGRectMake(0, y-3-17, rect.size.width - epingle.frame.width, 17)
                
                x = 0
                y = rect.size.height
                toolBar.frame = CGRectMake(x, y - toolBar.frame.size.height, rect.size.width, 44+19)
                
                
                
                
                
                
                if(!unePhoto.hidden) {
                    ///////Une photo afficher
                    
                    var wd = rect.size.width/2 - 40
                    x = rect.size.width/4 - wd/2
                    y =  28
                    mapType.frame = CGRectMake(x, y, wd , 30)
                    
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width/2, rect.size.height)
                    
                    x = rect.size.width/4
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                    
                    
                } else {
                    
                    
                    
                    x = rect.size.width/2 - 340/2
                    y =  28
                    mapType.frame = CGRectMake(x, y, 340, 30)
                    
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height)
                    x = rect.size.width/2
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                    
                }
                
                
            }
            
            
        }else{
            //////IPone////////
            
            if ((terminal.orientation == UIDeviceOrientation.Portrait) ) {
                ///portrait///////
                
                
                
                y = rect.size.height / 2
                x = 0
                unePhoto.frame = CGRectMake(x, y, rect.size.width, y)
                
                x = rect.size.width/2 - 340/2
                y =  28
                mapType.frame = CGRectMake(x, y, 340, 30)
                
                y = rect.size.height - 45
                x = rect.size.width
                epingle.frame = CGRectMake(x-10-60, y-3-17, 60, 17)
                position.frame = CGRectMake(0, y-3-17, rect.size.width - epingle.frame.width, 17)
                
                x = 0
                y = rect.size.height
                toolBar.frame = CGRectMake(x, y - toolBar.frame.size.height, rect.size.width, 44+19)
                
                if(!unePhoto.hidden) {
                    ///////Une photo afficher
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height/2)
                    x = rect.size.width/2
                    y = rect.size.height/4
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                } else {
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height)
                    x = rect.size.width/2
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                }
                
                
                
            } else {
                ///Paysage///////
                
                
                y = 0
                x = rect.size.width / 2
                unePhoto.frame = CGRectMake(x, y, x, rect.size.height)
                
                
                y = rect.size.height - 45
                x = rect.size.width
                epingle.frame = CGRectMake(x-10-60, y-3-17, 60, 17)
                position.frame = CGRectMake(0, y-3-17, rect.size.width - epingle.frame.width, 17)
                
                x = 0
                y = rect.size.height
                toolBar.frame = CGRectMake(x, y - toolBar.frame.size.height, rect.size.width, 44+19)
                
                
                
                
                
                
                if(!unePhoto.hidden) {
                    ///////Une photo afficher
                    
                    var wd = rect.size.width/2 - 40
                    x = rect.size.width/4 - wd/2
                    y =  28
                    mapType.frame = CGRectMake(x, y, wd , 30)
                    
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width/2, rect.size.height)
                    
                    x = rect.size.width/4
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                    
                    
                } else {
                   
                    
                    
                    x = rect.size.width/2 - 340/2
                    y =  28
                    mapType.frame = CGRectMake(x, y, 340, 30)
                    
                    x = 0
                    y = 0
                    map.frame = CGRectMake(x, x, rect.size.width, rect.size.height)
                    x = rect.size.width/2
                    y = rect.size.height/2
                    
                    targetImg.frame = CGRectMake(x-15, y-15, 30 , 30 )
                    
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
        
        
        
    
    }

   
    
    ///////////////////////////  ACTION  //////////////////////////////////
    
    
    func trouverMoi(sender: UIButton) {
        
        locMngr.startUpdatingLocation()

    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let loca = locations[locations.count-1] as CLLocation
        let center = CLLocationCoordinate2D(latitude: loca.coordinate.latitude, longitude: loca.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        map.setRegion(region, animated: true)
        map.setNeedsDisplay()
        ////
        position.text = String(format: "Positionnée sur : %2.3f , %2.3f",manager.location.coordinate.latitude,manager.location.coordinate.longitude )
        coordGenerale = manager.location.coordinate
        ///
        locMngr.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alert = UIAlertView()
        alert.addButtonWithTitle("OK")
        alert.title = "Erreur"
        alert.message = "Localisation désactivée"
        alert.show()
    }
    
    
    
    
     func changeCarte(sender: UIButton) {
        
        if(mapType.selectedSegmentIndex == 0) {
            typeMap = 0
            self.D3Carte()
            position.text = "Visualisation en mode 3D"
            
        }
        
        if(mapType.selectedSegmentIndex == 1) {
            typeMap = 1
            map.showsBuildings = false
            map.mapType = MKMapType.Standard
            
        }
        
        if(mapType.selectedSegmentIndex == 2) {
            typeMap = 2
            map.mapType = MKMapType.Satellite
            position.text = "Visualisation en mode Satellite"
            
        }
        if(mapType.selectedSegmentIndex == 3) {
            typeMap = 3
            map.mapType = MKMapType.Hybrid
            position.text = "Visualisation en mode Hybrid"
            
        }
    
    
    }
    
    func D3Carte(){
        
        var altitude = Double(50)
        
        var pointdeVue = CLLocationCoordinate2DMake(coordGenerale.latitude - altitude/10000 , coordGenerale.longitude)
        let region = MKCoordinateRegion(center: coordGenerale , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        map.showsBuildings = true
        
        cameraMap = MKMapCamera(lookingAtCenterCoordinate: coordGenerale, fromEyeCoordinate: pointdeVue, eyeAltitude: altitude)
        cameraMap.heading = 0
        map.camera = cameraMap
    }
    
    
    
    
    func ajouter(sender: UIButton) {
        compteur = compteur + 1
        
        annot = Annotation(coordinate: map.centerCoordinate, title: String(format: "Contact %d", compteur), subtitle: "Pas de contact")
        
        annotationSelected = annot
        
        map.addAnnotation(annot)

    }
    
    func supprimer (sender: UIButton) {
        
       map.removeAnnotation(annotationSelected)
       unePhoto.hidden = true
       drawRect(rect)
        
    }

    
    ///////////////////////////////////////////////////////////////////
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let region = MKCoordinateRegion(center: map.centerCoordinate , span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35))
        mapView.setRegion(region, animated: true)
        
        delete.enabled = false
        book.enabled = false
        photo.enabled = false
        archive.enabled = false
    }
    
   
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
       
        
        annotationSelected = view.annotation
        
        
        delete.enabled = true
        book.enabled = true
        photo.enabled = true
        archive.enabled = true
        
        var coo = CLLocationCoordinate2D(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude)
    
        position.text = String(format: "Positionnée sur : %2.3f , %2.3f",coo.latitude, coo.longitude)
        
        //Ajouter l'image au tableau + ajouter le pin
        annot = annotationSelected as Annotation
        
        if (annot.haveImage) {
            
            afficherImage()
        }
        
        
        
        
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        
        delete.enabled = false
        book.enabled = false
        photo.enabled = false
        archive.enabled = false
        
        unePhoto.hidden = true
        
        deaffichImage()
        
        if(mapType.selectedSegmentIndex == 0) {
            
            self.D3Carte()
            position.text = "Visualisation en mode 3D"
            
        }
        
        if(typeMap == 0) {
            position.text = "Visualisation en mode 3D"
        }
        
        if(typeMap == 1) {
            position.text = ""
        }
        if(typeMap == 2) {
            position.text = "Visualisation en mode Satellite"
        }
        if(typeMap == 3) {
            position.text = "Visualisation en mode Hybrid"
        }

        
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation.isKindOfClass(MKUserLocation)) {
            return nil;
        }
        
        
        var pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ppm")
        
        pin.pinColor = MKPinAnnotationColor.Green
        
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
        
        return pin
    }
    
  

    ////////////////ADRESS BOOK//////////////
    
    
    
    func contactBook() {
        abnavctrl.peoplePickerDelegate = self
        
        
        
        if (!isPad) {
            myController?.presentViewController(abnavctrl, animated: true, completion: nil)
            
        }else {
            
            
            pop2 = UIPopoverController(contentViewController: abnavctrl)
            pop2.popoverContentSize = CGSizeMake(250, 500)
            pop2.delegate = self
            pop2.presentPopoverFromBarButtonItem(book, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
            
        }


        
    }
    
    
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
        var xFN = ABRecordCopyValue(person, kABPersonFirstNameProperty)?
        var xLN = ABRecordCopyValue(person, kABPersonLastNameProperty)?
        
        if xFN != nil {
            let fn = xFN!.takeRetainedValue() as String
        
            
        annot.subtitle = fn
            
            
        }
        
        if xLN != nil {
            
            let ln = xLN!.takeRetainedValue() as String
            annot.subtitle = annot.subtitle + " " + ln
            
            
        }
        
        map.deselectAnnotation(annotationSelected, animated: true)
        map.selectAnnotation(annotationSelected, animated: true)
        //récupérer l'image associé 
        
        let tmp = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?
        
        if tmp != nil {
            let img = tmp!.takeRetainedValue()
            photo.image = UIImage(data: img)
            
        } else {
            photo.image = nil
        }
        
        
        unePhoto.hidden = true
        drawRect(rect)
       
        
    }
    
    
    
    
    
    //////////APPAREEIL PHOTO////////
    
    
    func organizer () {
        
        photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
       
        
        if (!isPad) {
             myController?.presentViewController(photoPicker, animated: true, completion: nil)
            
        }else {
            
            
            pop3 = UIPopoverController(contentViewController: photoPicker)
            pop3.popoverContentSize = CGSizeMake(250, 500)
            pop3.delegate = self
            pop3.presentPopoverFromBarButtonItem(book, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
            
        }

    
    }
    
    
    func prendrePhoto () {
        
        photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        var mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)
        photoPicker.mediaTypes = mediaTypes!
        
        
        
        
        
        if (!isPad) {
            myController?.presentViewController(photoPicker, animated: true, completion: nil)
            
        }else {
            
            
            pop = UIPopoverController(contentViewController: photoPicker)
            pop.popoverContentSize = CGSizeMake(250, 500)
            pop.delegate = self
            pop.presentPopoverFromBarButtonItem(book, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
            
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        
        
        picker.dismissViewControllerAnimated(true , completion: nil)
        var mediaType : NSString = info.objectForKey(UIImagePickerControllerMediaType) as NSString
        
        if(CFStringCompare(mediaType, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive) == CFComparisonResult.CompareEqualTo){
            
            var img : UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            //Ajouter l'image au tableau + ajouter le pin
            
            annot.image = img
            annot.haveImage = true
            afficherImage()
            
        } else {
            
            var alertCam = UIAlertView()
            alertCam.addButtonWithTitle("OK")
            alertCam.title = "Erreur"
            alertCam.message = "Vous avez enregister un film"
            
            self.addSubview(alertCam)
            alertCam.show()

            
        }
        
        
    }
    
    
    func afficherImage() {
        
        unePhoto.hidden = false
        unePhoto.image = annot.image
        drawRect(rect)
        
    }
    
    func deaffichImage() {
        unePhoto.hidden = true
        drawRect(rect)
    }
    
    
    
    
    
}
