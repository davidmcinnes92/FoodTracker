//
//  MealViewController.swift
//  FoodTracker
//
//  Created by David Mcinnes on 23/06/2020.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate,
                    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var appInfoButton: UIButton!
    
    /*
     
    This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
    or constructed as part of adding a new meal.
    */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // Enable the save button only if the text field has a valid Meal name
        updateSaveButtonState()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button when editing.
        saveButton.isEnabled = false
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info) ")
        }
        
        // Set the photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a View Controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling...", log: OSLog.default, type: .default)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to the MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil )
    }
    
    // Called when the Get App Info button is pressed
    @IBAction func appInfoButtonPressed(_ sender: UIButton) {
        print("This is a test of the button")
        
        // Display an alert showing the app information
        let alertController = UIAlertController(title: "Test Alert",
                                                message: "This is an alert!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "You know it!", style: .default))
        present(alertController, animated: true, completion: nil)
                
        httpTest()
    }
    
    // MARK: Private methods
    private func updateSaveButtonState() {
        // Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // A simple FizzBuzz implementation in Swift
    private func fizzBuzz() {
        for number in 1...100 {
            if number % 3 == 0 && number % 5 == 0 {
                print("FizzBuzz")
            } else if number % 3 == 0{
                print("Fizz")
            } else if number % 5 == 0 {
                print("Buzz")
            } else {
                print(number)
            }
        }
    }
    
    // Create a simple HTTP request
    private func httpTest() {
        let url = URL(string: "https://www.stackoverflow.com")!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8))
        }
        
        task.resume()
    }
}

