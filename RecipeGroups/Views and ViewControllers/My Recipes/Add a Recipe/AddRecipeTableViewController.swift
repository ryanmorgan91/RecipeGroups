//
//  ChildCreateRecipeTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/21/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension AddRecipeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Appropriately respond to user tapping the recipe image based on the available image sources
    func userTappedRecipeImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose an Image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeImage = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
}

class AddRecipeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var cookingTimePickerView: UIPickerView!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var cookTimeImageView: UIImageView!
    @IBOutlet weak var difficultyImageView: UIImageView!
    @IBOutlet weak var ingredientsImageView: UIImageView!
    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    let categoryPickerViewIndexPath = IndexPath(row: 1, section: 3)
    let cookingTimePickerViewIndexPath = IndexPath(row: 3, section: 3)
    let difficultyPickerViewIndexPath = IndexPath(row: 5, section: 3)
    let descriptionIndexPath = IndexPath(row: 0, section: 2)
    let recipeImageIndexPath = IndexPath(row: 0, section: 0)
    let ingredientsIndexPath = IndexPath(row: 0, section: 4)
    let stepsIndexPath = IndexPath(row: 1, section: 4)
    var recipeDict: [String: Any] = [:]
    var isEditingRecipe: Bool = false
    var recipeBeingEdited: Recipe?
    
    var isCategoryPickerShown: Bool = false {
        didSet {
            categoryPickerView.isHidden = !isCategoryPickerShown
        }
    }
    
    var isCookingTimePickerShown: Bool = false {
        didSet {
            cookingTimePickerView.isHidden = !isCookingTimePickerShown
        }
    }
    
    var isDifficultyPickerShown: Bool = false {
        didSet {
            difficultyPickerView.isHidden = !isDifficultyPickerShown
        }
    }
    
    var recipeImage: UIImage? {
        didSet {
            recipeImageView.image = recipeImage
        }
    }
    
    var ingredients: [String] = [""]
    var steps: [String] = [""]
    
    // Fixes a bug related to reloading tableViews and losing the current scroll position
    var currentScrollPosition: CGFloat?
    
    override func viewDidLayoutSubviews() {
        descriptionTextView.centerVertically()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        // Set delegates and dataSources
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        cookingTimePickerView.delegate = self
        cookingTimePickerView.dataSource = self
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        descriptionTextView.delegate = self
        
        // Set colors
        titleImageView.tintColor = CustomStyles.shared.customPink
        categoryImageView.tintColor = CustomStyles.shared.customPink
        cookTimeImageView.tintColor = CustomStyles.shared.customPink
        difficultyImageView.tintColor = CustomStyles.shared.customPink
        ingredientsImageView.tintColor = CustomStyles.shared.customPink
        stepImageView.tintColor = CustomStyles.shared.customPink
        cameraIcon.tintColor = CustomStyles.shared.customPink
        descriptionTextView.tintColor = CustomStyles.shared.customPink
        addImageLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        titleTextField.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        descriptionTextView.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        categoryLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        cookingTimeLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        difficultyLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        ingredientsLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        stepsLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        
        // Add placeholder for UITextView
        if !isEditingRecipe {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
        
        if isEditingRecipe {
            setupRecipeEditing()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case categoryPickerView:
            return Recipe.Category.allCases.count
        case cookingTimePickerView:
            return Recipe.CookTime.allCases.count
        case difficultyPickerView:
            return Recipe.Difficulty.allCases.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (recipeImageIndexPath.section, recipeImageIndexPath.row):
            return 250.0
        case (descriptionIndexPath.section, descriptionIndexPath.row):
            return 150.0
        case (categoryPickerViewIndexPath.section, categoryPickerViewIndexPath.row):
            if isCategoryPickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (cookingTimePickerViewIndexPath.section, cookingTimePickerViewIndexPath.row):
            if isCookingTimePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (difficultyPickerViewIndexPath.section, difficultyPickerViewIndexPath.row):
            if isDifficultyPickerShown {
                return 216.0
            } else {
                return 0.0
            }
        default:
            return 62.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (categoryPickerViewIndexPath.section, categoryPickerViewIndexPath.row - 1):
            isCategoryPickerShown = !isCategoryPickerShown
            updateTableView()
        case (cookingTimePickerViewIndexPath.section, cookingTimePickerViewIndexPath.row - 1):
            isCookingTimePickerShown = !isCookingTimePickerShown
            updateTableView()
        case (difficultyPickerViewIndexPath.section, difficultyPickerViewIndexPath.row - 1):
            isDifficultyPickerShown = !isDifficultyPickerShown
            updateTableView()
        case (recipeImageIndexPath.section, recipeImageIndexPath.row):
            userTappedRecipeImage()
        case (ingredientsIndexPath.section, ingredientsIndexPath.row):
            performSegue(withIdentifier: "SegueFromAddRecipeToIngredients", sender: nil)
        case (stepsIndexPath.section, stepsIndexPath.row):
            performSegue(withIdentifier: "SegueFromAddRecipeToSteps", sender: nil)
        default:
            break
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if isEditingRecipe {
            navigationController?.popViewController(animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case categoryPickerView:
            return Recipe.Category.allCases[row].rawValue
        case cookingTimePickerView:
            return Recipe.CookTime.allCases[row].rawValue
        case difficultyPickerView:
            return Recipe.Difficulty.allCases[row].rawValue
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryPickerView:
            updateCategoryLabel()
        case cookingTimePickerView:
            updateCookingTimeLabel()
        case difficultyPickerView:
            updateDifficultyLabel()
        default:
            break
        }
    }
    
    func updateCategoryLabel() {
        categoryLabel.text = Recipe.Category.allCases[categoryPickerView.selectedRow(inComponent: 0)].rawValue
    }
    
    func updateCookingTimeLabel() {
        cookingTimeLabel.text = Recipe.CookTime.allCases[cookingTimePickerView.selectedRow(inComponent: 0)].rawValue
    }
    
    func updateDifficultyLabel() {
        difficultyLabel.text = Recipe.Difficulty.allCases[difficultyPickerView.selectedRow(inComponent: 0)].rawValue
    }

    // Fixes a bug related to reloading tableViews and losing the current scroll position
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (currentScrollPosition != nil) {
            tableView.setContentOffset(CGPoint(x: 0, y: currentScrollPosition!), animated: false)
        }
    }
    
    // Fixes a bug related to reloading tableViews and losing the current scroll position
    func updateTableView() {
        UIView.animate(withDuration: 0.15) {
            self.currentScrollPosition = self.tableView.contentOffset.y
            self.view.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.currentScrollPosition = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromAddRecipeToIngredients" {
            let destinationViewController = segue.destination as! AddIngredientsTableViewController
            destinationViewController.ingredients = ingredients
  
        } else if segue.identifier == "SegueFromAddRecipeToSteps" {
            let destinationViewController = segue.destination as! AddStepsTableViewController
            destinationViewController.steps = steps
        }
    }
    
    @IBAction func unwindToAddRecipe(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "SaveUnwindFromAddIngredients" {
            let sourceViewController = unwindSegue.source as! AddIngredientsTableViewController
            let ingredients = sourceViewController.ingredients
            self.ingredients = ingredients
        } else if unwindSegue.identifier == "SaveUnwindFromAddSteps" {
            let sourceViewController = unwindSegue.source as! AddStepsTableViewController
            let steps = sourceViewController.steps
            self.steps = steps
        }
    }
    
    // Check if all fields have been filled out
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if (steps == [""]) || (ingredients == [""]) || (recipeImage == nil) || (titleTextField.text == "") ||
            (descriptionTextView.text == "") || (descriptionTextView.text == "Description") ||
            (categoryLabel.text == "Category") || (cookingTimeLabel.text == "Preparation Time") ||
            (difficultyLabel.text == "Difficulty")
        {
            let alertController = UIAlertController(title: "Oops", message: "All fields must be completed to save a recipe", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Check if the user already has a recipe with the same name
            let recipeTitle = titleTextField.text!
            
            if RecipeController.shared.savedRecipes.contains(where: { $0.name == recipeTitle }) && !isEditingRecipe {
                
                let alertController = UIAlertController(title: "Oops", message: "You cannot have two recipes with the same name. Note that \"your\" recipes include recipes you have liked.", preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                
                alertController.addAction(dismissAction)
                present(alertController, animated: true, completion: nil)
            } else {
                let email = UserController.shared.user?.email ?? "thisDevice"
                
                let recipe = Recipe(name: titleTextField.text!, image: recipeImage!, cookTime: Recipe.CookTime(rawValue: cookingTimeLabel.text!)!, cookingDifficulty: Recipe.Difficulty(rawValue: difficultyLabel.text!)!, category: Recipe.Category(rawValue: categoryLabel.text!)!, description: descriptionTextView.text!, ingredients: ingredients, steps: steps, author: email)
                
                if UserController.shared.userIsLoggedIn {
                    if isEditingRecipe {
                        
                        guard let recipeBeingEdited = recipeBeingEdited else { return }
                        
                        RecipeController.shared.delete(recipe: recipeBeingEdited)
                        RecipeController.shared.deleteRecipeFromServer(recipe: recipeBeingEdited) { (_) in
                            RecipeController.shared.sendRecipe(recipe: recipe, completion: {
                                // Pop to root once sendRecipe() has been called
                                self.backToPreviousViewController()
                            })
                            
                            
                        }
                    } else {
                        RecipeController.shared.sendRecipe(recipe: recipe) {
                            self.backToPreviousViewController()
                        }
                        
                    }
                } else {
                    if isEditingRecipe {
                        guard let recipeBeingEdited = recipeBeingEdited else { return }
                        
                        RecipeController.shared.delete(recipe: recipeBeingEdited)
                    }
                    RecipeController.shared.processRecipeIfUserIsNone(recipe: recipe)
                    backToPreviousViewController()
                }
            }
        }
    }
    
    func backToPreviousViewController() {
        // If the user edited the recipe, pop back to the root view controller on the navigation stack
        if isEditingRecipe {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // encode partially filled out form if app will be restored
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        recipeDict.removeAll()
        
        if titleTextField.text != "" { recipeDict["title"] = titleTextField.text }
        if descriptionTextView.text != "" && descriptionTextView.text != "Description" { recipeDict["description"] = descriptionTextView.text }
        if categoryLabel.text != "Category" { recipeDict["category"] = categoryLabel.text }
        if cookingTimeLabel.text != "Preparation Time" { recipeDict["cookingTime"] = cookingTimeLabel.text }
        if difficultyLabel.text != "Difficulty" { recipeDict["difficulty"] = difficultyLabel.text }
        if recipeImage != nil { recipeDict["recipeImage"] = recipeImage }
        if ingredients != [""] { recipeDict["ingredients"] = ingredients }
        if steps != [""] { recipeDict["steps"] = steps }
        
        coder.encode(recipeDict, forKey: "recipeDict")
    }
    
    // Decode restorable state based on partially filled out form
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        recipeDict.removeAll()
        
        recipeDict = coder.decodeObject(forKey: "recipeDict") as! [String: Any]
        updateViewFrom(recipeDict)
    }
    
    // Update the views fields based on which forms were partially filled in
    func updateViewFrom(_ recipeDict: [String: Any]) {
        let keys = recipeDict.keys
        if keys.contains("title") { titleTextField.text = (recipeDict["title"] as! String) }
        if keys.contains("description") { descriptionTextView.text = (recipeDict["description"] as! String) }
        if keys.contains("category") { categoryLabel.text = (recipeDict["category"] as! String) }
        if keys.contains("cookingTime") { cookingTimeLabel.text = (recipeDict["cookingTime"] as! String) }
        if keys.contains("difficulty") { difficultyLabel.text = (recipeDict["difficulty"] as! String) }
        if keys.contains("recipeImage") { recipeImage = (recipeDict["recipeImage"] as! UIImage) }
        if keys.contains("ingredients") { ingredients = (recipeDict["ingredients"] as! [String]) }
        if keys.contains("steps") { steps = (recipeDict["steps"] as! [String]) }
    }
    
    func setupRecipeEditing() {
        guard let recipe = recipeBeingEdited else { return }
        
        recipeImageView.image = recipe.image
        recipeImage = recipe.image
        titleTextField.text = recipe.name
        descriptionTextView.text = recipe.description
        categoryLabel.text = recipe.category.rawValue
        cookingTimeLabel.text = recipe.cookTime.rawValue
        difficultyLabel.text = recipe.cookingDifficulty.rawValue
        ingredients = recipe.ingredients
        steps = recipe.steps
    }
}
