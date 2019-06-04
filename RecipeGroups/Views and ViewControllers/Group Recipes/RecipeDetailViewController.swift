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

    private lazy var childSteps: ChildStepsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildSteps") as! ChildStepsTableViewController
        
        return viewController
    }()
    private lazy var childIngredients: ChildIngredientsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildIngredients") as! ChildIngredientsTableViewController
        
        return viewController
    }()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipeSwitch: CustomSwitchView!
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
    
    let customColors = CustomColors()
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
        switchBaseImage.tintColor = customColors.customGray
        switchActiveImage.layer.cornerRadius = 25
        switchActiveImage.tintColor = customColors.customPink
    }
    
    @IBAction func ingredientsButtonTapped(_ sender: UIButton) {
        animateSwitch()
    }
    
    @IBAction func stepByStepButtonTapped(_ sender: UIButton) {
        animateSwitch()
    }
    
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
        setupImage(with: recipe)
        
        /* Comment the below to get rid of samples */
//        recipeImage.image = recipe.image
        
        recipeTitleLabel.text = recipe.name
        recipeCookTimeLabel.text = recipe.cookTime.rawValue
        difficultyLabel.text = recipe.cookingDifficulty.rawValue
        descriptionLabel.text = recipe.description
        cookTimeImage.tintColor = customColors.customPink
        difficultyImage.tintColor = customColors.customPink
        
    }
    
    func setupImage(with recipe: Recipe) {
        RecipeController.shared.fetchImage(url: recipe.imageURL!) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.recipeImage.image = image
            }
        }
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
            let pdfDocument = PDFDocument(data: pdfData)
    
            let activityController = UIActivityViewController(activityItems: [pdfDocument as Any], applicationActivities: nil)
            
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

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let recipe = recipe else { return }
        RecipeController.shared.saveLikedRecipe(recipe)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let recipe = recipe else { return }
        // to do
        // coder.encode(...
    }
    

}
