//
//  RecipeDetailViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import PDFKit

class RecipeDetailViewController: UIViewController {

    // Uses lazy initialization to set the childSteps variable the first time it's used
    private lazy var childSteps: ChildStepsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildSteps") as! ChildStepsTableViewController
        
        return viewController
    }()
    
    // Uses lazy initialization to set the childIngredients variable the first time it's used
    private lazy var childIngredients: ChildIngredientsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildIngredients") as! ChildIngredientsTableViewController
        
        return viewController
    }()
    
    @IBOutlet weak var recipeSwitch: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var switchBaseImage: UIImageView!
    @IBOutlet weak var switchActiveImage: UIImageView!
    @IBOutlet weak var switchActiveTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cookTimeImage: UIImageView!
    @IBOutlet weak var difficultyImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var ingredientsButton: UIButton!
    @IBOutlet weak var stepsButton: UIButton!
    
    var recipe: Recipe?
    var showSteps: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomSwitch()
        addChildView(withChild: childSteps)
        guard let recipe = recipe else { return }
        childSteps.steps = recipe.steps
        childSteps.tableView.reloadData()
        setupView()
    }
    
    func setupCustomSwitch() {
        switchBaseImage.layer.cornerRadius = 25
        switchBaseImage.tintColor = CustomStyles.shared.customGray
        switchActiveImage.layer.cornerRadius = 25
        switchActiveImage.tintColor = CustomStyles.shared.customPink
    }
    
    @IBAction func ingredientsButtonTapped(_ sender: UIButton) {
        animateSwitch()
    }
    
    @IBAction func stepByStepButtonTapped(_ sender: UIButton) {
        animateSwitch()
    }
    
    // If the switch is tapped, animate it and move it left/right
    func animateSwitch() {
        if showSteps {
            showSteps = !showSteps
            self.switchActiveTrailingConstraint.constant = self.recipeSwitch.frame.width / 2
            UIView.animate(withDuration: 0.5) {
                self.recipeSwitch.layoutIfNeeded()
                self.updateView()
            }
        } else {
            showSteps = !showSteps
            self.switchActiveTrailingConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.recipeSwitch.layoutIfNeeded()
                self.updateView()
            }
        }
    }
    
    func addChildView(withChild child: UITableViewController) {
        addChild(child)
        containerView.addSubview(child.tableView)
        
        child.tableView.frame = containerView.bounds
        child.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.tableView.layoutMargins = UIEdgeInsets.zero
        child.didMove(toParent: self)
    }
    
    // If showSteps = true, add the childSteps view onto the current view, else add the childIngredients view
    func updateView() {
        guard let recipe = recipe else { return }
        if showSteps {
            removeChildView(childViewController: childIngredients)
            addChildView(withChild: childSteps)
            childSteps.steps = recipe.steps
            childSteps.tableView.reloadData()
        } else {
            removeChildView(childViewController: childSteps)
            addChildView(withChild: childIngredients)
            childIngredients.ingredients = recipe.ingredients
            childIngredients.tableView.reloadData()
        }
    }
    
    func removeChildView(childViewController child: UITableViewController) {
        child.willMove(toParent: nil)
        child.tableView.removeFromSuperview()
        child.removeFromParent()
    }
    
    func setupView() {
        guard let recipe = recipe else { return }
        self.navigationItem.title = recipe.name

        recipeImage.image = recipe.image
        recipeTitleLabel.text = recipe.name
        recipeCookTimeLabel.text = recipe.cookTime.rawValue
        difficultyLabel.text = recipe.cookingDifficulty.rawValue
        descriptionLabel.text = recipe.description
        cookTimeImage.tintColor = CustomStyles.shared.customBlue
        difficultyImage.tintColor = CustomStyles.shared.customBlue
        
        recipeTitleLabel.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 20)
        recipeCookTimeLabel.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 17)
        difficultyLabel.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 17)
        descriptionLabel.font = UIFont(name: CustomStyles.shared.customFontName, size: 17)
        ingredientsButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 18)
        stepsButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 18)
        likeButton.titleLabel?.font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 17)
        descriptionLabel.textColor = UIColor.gray
        
        if let isLiked = recipe.isLiked {
            likeButton.isSelected = isLiked
        }
        
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitle("", for: .selected)
    }
    
    @IBAction func exportButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pdfAction = UIAlertAction(title: "View as PDF", style: .default) { (_) in
            self.performSegue(withIdentifier: "SegueFromRecipeDetailToPDF", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let shareAction = UIAlertAction(title: "Share as PDF", style: .default) { (_) in
            guard let recipe = self.recipe else { return }
            let pdfData = PDFCreator.shared.createPDFFromRecipe(recipe: recipe)
            let activityController = UIActivityViewController(activityItems: [pdfData as Data], applicationActivities: nil)
            
            // On iPads, a UIActivityController is presented inside of a popover
            activityController.popoverPresentationController?.sourceView = self.view
            self.present(activityController, animated: true, completion: nil)
        }
        alertController.addAction(pdfAction)
        alertController.addAction(cancelAction)
        alertController.addAction(shareAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PDFViewController {
            destinationViewController.recipe = recipe
        }
    }

    // Change the like button selected state and save the recipe to local drive
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let recipe = recipe else { return }
        
        if let isLiked = recipe.isLiked {
            recipe.isLiked = !isLiked
            likeButton.isSelected = recipe.isLiked!
            
        } else {
            // If optional isLiked value was previously nil, set isLiked o true and save the recipe locally
            recipe.isLiked = true
            likeButton.isSelected = true
            RecipeController.shared.saveLikedRecipe(recipe)
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let recipe = recipe else { return }
        coder.encode(recipe.name, forKey: "recipeName")
        coder.encode(recipe.author, forKey: "recipeAuthor")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        guard let recipeName = coder.decodeObject(forKey: "recipeName") as? String else { return }
        guard let recipeAuthor = coder.decodeObject(forKey: "recipeAuthor") as? String else { return }
        recipe = RecipeController.shared.recipes.filter({ $0.name == recipeName }).filter({ $0.author == recipeAuthor }).first
       
        if showSteps {
            childSteps.steps = recipe!.steps
            childSteps.tableView.reloadData()
        } else {
            childIngredients.ingredients = recipe!.ingredients
            childIngredients.tableView.reloadData()
        }
        
        setupView()
    }
}
