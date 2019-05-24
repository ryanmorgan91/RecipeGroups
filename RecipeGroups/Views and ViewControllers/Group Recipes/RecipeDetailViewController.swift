//
//  RecipeDetailViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/13/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    private lazy var childSteps: ChildStepsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildSteps") as! ChildStepsTableViewController
        self.addChild(viewController)
        
        return viewController
    }()
    private lazy var childIngredients: ChildIngredientsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ChildIngredients") as! ChildIngredientsTableViewController
        self.addChild(viewController)
        
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
    
    
    let customColors = CustomColors()
    
    var recipe: Recipe?
    
    var showSteps: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomSwitch()
        addChildView(withChild: childSteps)
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
            //        child.tableView.center = containerView.center
        child.tableView.frame = containerView.bounds
        child.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.tableView.layoutMargins = UIEdgeInsets.zero
        
//        child.tableView.separatorInset = UIEdgeInsets.zero
        child.didMove(toParent: self)
    }
    
    func updateView() {
        guard let recipe = recipe else { return }
        if showSteps {
            removeChildView(childViewController: childIngredients)
            addChildView(withChild: childSteps)
            childSteps.steps = recipe.steps
        } else {
            removeChildView(childViewController: childSteps)
            addChildView(withChild: childIngredients)
            childIngredients.ingredients = recipe.ingredients
        }
    }
    
    func removeChildView(childViewController child: UITableViewController) {
        child.willMove(toParent: nil)
        child.tableView.removeFromSuperview()
        child.removeFromParent()
    }
    
    func setupView() {
        guard let recipe = recipe else { return }
        
//        setupImage(with: recipe)
        
        /* Comment the below to get rid of samples */
        recipeImage.image = recipe.image
        
        recipeTitleLabel.text = recipe.name
        recipeCookTimeLabel.text = recipe.cookTime.rawValue
        difficultyLabel.text = recipe.cookingDifficulty.rawValue
        descriptionLabel.text = recipe.description
    }
    
    func setupImage(with recipe: Recipe) {
        
        RecipeController.shared.fetchImage(url: recipe.imageURL!) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.recipeImage.image = image
            }
        }
    }
}
