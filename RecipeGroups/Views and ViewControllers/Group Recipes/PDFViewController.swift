//
//  PrintViewController.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    var recipe: Recipe?
    
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
//        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        view.layoutIfNeeded()
        
        addPDFToView(to: pdfView, fromRecipe: recipe)
    }

    func addPDFToView(to pdfView: PDFView, fromRecipe recipe: Recipe) {
        let pdfData = PDFCreator.shared.createPDFFromRecipe(recipe: recipe)
        let pdfDocument = PDFDocument(data: pdfData)
        pdfView.document = pdfDocument
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
