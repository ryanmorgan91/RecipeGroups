//
//  ChildCreateRecipeTableViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/21/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

extension AddRecipeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

class AddRecipeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
    let categoryPickerViewIndexPath = IndexPath(row: 1, section: 3)
    let cookingTimePickerViewIndexPath = IndexPath(row: 3, section: 3)
    let difficultyPickerViewIndexPath = IndexPath(row: 5, section: 3)
    let descriptionIndexPath = IndexPath(row: 0, section: 2)
    let recipeImageIndexPath = IndexPath(row: 0, section: 0)
    let ingredientsIndexPath = IndexPath(row: 0, section: 4)
    let stepsIndexPath = IndexPath(row: 1, section: 4)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupView() {
        let customColors = CustomColors()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        cookingTimePickerView.delegate = self
        cookingTimePickerView.dataSource = self
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        titleImageView.tintColor = customColors.customPink
        descriptionImageView.tintColor = customColors.customPink
        categoryImageView.tintColor = customColors.customPink
        cookTimeImageView.tintColor = customColors.customPink
        difficultyImageView.tintColor = customColors.customPink
        ingredientsImageView.tintColor = customColors.customPink
        stepImageView.tintColor = customColors.customPink
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
        print(ingredients)
        if segue.identifier == "SegueFromAddRecipeToIngredients" {
            let destinationViewController = segue.destination as! AddIngredientsTableViewController
            destinationViewController.ingredients = ingredients
            print(ingredients)
            print(destinationViewController.ingredients)
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
            print("Ingredients from AddRecipe Controller: \(ingredients)")
        } else if unwindSegue.identifier == "SaveUnwindFromAddSteps" {
            let sourceViewController = unwindSegue.source as! AddStepsTableViewController
            let steps = sourceViewController.steps
            self.steps = steps
            print("Steps from AddRecipe Controller: \(steps)")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if (steps == [""]) || (ingredients == [""]) || (recipeImage == nil) || (titleTextField.text == "") ||
            (descriptionTextView.text == "Description" || descriptionTextView.text == "") ||
            (categoryLabel.text == "Category") || (cookingTimeLabel.text == "Preparation Time") ||
            (difficultyLabel.text == "Difficulty")
        {
            let alertController = UIAlertController(title: "Oops", message: "All fields must be completed to save a recipe", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else if RecipeController.shared.recipes.contains(where: { $0.name == titleTextField.text! }) {
            let alertController = UIAlertController(title: "Oops", message: "You cannot have two recipes with the same name", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let email = UserController.shared.user?.email ?? ""
            
            let recipe = Recipe(name: titleTextField.text!, image: recipeImage!, cookTime: Recipe.CookTime(rawValue: cookingTimeLabel.text!)!, cookingDifficulty: Recipe.Difficulty(rawValue: difficultyLabel.text!)!, category: Recipe.Category(rawValue: categoryLabel.text!)!, description: descriptionTextView.text!, ingredients: ingredients, steps: steps, author: email)
            RecipeController.shared.sendRecipe(recipe: recipe) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
