//
//  PrintViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController, UIPrintInteractionControllerDelegate {

    var recipe: Recipe?
    var pdfDocument: PDFDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPDFView()
    }
    
    func setupPDFView() {
        guard let recipe = recipe else { return }
        
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pdfView)
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        pdfView.autoScales = true
        view.layoutIfNeeded()
        
        addPDFToView(to: pdfView, fromRecipe: recipe)
    }

    func addPDFToView(to pdfView: PDFView, fromRecipe recipe: Recipe) {
        let pdfData = PDFCreator.shared.createPDFFromRecipe(recipe: recipe)
        pdfDocument = PDFDocument(data: pdfData)
        pdfView.document = pdfDocument
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // Initialize a printController object, set its properties, and present it
    @IBAction func printButtonTapped(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else { return }
        
        let printController = UIPrintInteractionController.shared
        printController.delegate = self
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printController.printInfo = printInfo
        printController.printingItem = PDFCreator.shared.createPDFFromRecipe(recipe: recipe)
        printController.present(animated: true, completionHandler: nil)
    }
    
    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self
    }
}
