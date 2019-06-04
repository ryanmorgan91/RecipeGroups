//
//  PDFCreator.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/31/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit
import CoreText

class PDFCreator {
    
    static let shared = PDFCreator()
    static let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
    static let margin: CGFloat = 50
    let printablePageRect = PDFCreator.pageRect.insetBy(dx: PDFCreator.margin, dy: PDFCreator.margin)
    let spacing: CGFloat = 10
    var currentOffset = CGPoint(x: PDFCreator.margin, y: PDFCreator.margin)
    
    // Creates a PDF based on a custom type "Recipe"
    // Returns PDF as Data, which can be shown in a PDFKit PDFViewer
    func createPDFFromRecipe(recipe: Recipe) -> Data {
        currentOffset = CGPoint(x: PDFCreator.margin, y: PDFCreator.margin)
        
        let renderer = UIGraphicsPDFRenderer(bounds: PDFCreator.pageRect)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            addRecipeTitle(title: recipe.name)
            addImage(fromRecipe: recipe)
            addRecipeDescription(description: recipe.description)
            
            addLineSeparator(height: 0.5)
            addBulletedText(text: recipe.ingredients)
            addLineSeparator(height: 0.5)
            print("Offset Y before recipe steps: \(currentOffset.y)")
            addBulletedText(text: recipe.steps)
        }
        
        return data
    }
    
    func addRecipeTitle(title: String) {

        let fontName: String = "Avenir Next Condensed"
        let defaultFont: UIFont = .systemFont(ofSize: 26.0)
        let font = UIFont(name: fontName, size: 26.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: title, attributes: textAttributes)
        
        renderText(text: attributedString)
    }
    
    func addImage(fromRecipe recipe: Recipe) {
        guard let image = recipe.image else { return }
        renderImage(image: image)
    }
    
    func addRecipeDescription(description: String) {
        
        // Setting the string settings
        let fontName: String = "Avenir Next Condensed"
        let defaultFont: UIFont = .systemFont(ofSize: 16.0)
        let font = UIFont(name: fontName, size: 16.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let textAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: description, attributes: textAttributes)
        
        renderText(text: attributedString)
    }
    
    func addBulletedText(text: [String]) {
        
        // Setting the string settings
        let fontName: String = "Avenir Next Condensed"
        let defaultFont: UIFont = .systemFont(ofSize: 12.0)
        let font = UIFont(name: fontName, size: 12.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let textAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let bullet: String = "\u{2022}"
        
        for i in 0...text.count - 1 {
            let bulletedString = "\(bullet)   \(text[i])"
            let attributedString = NSMutableAttributedString(string: bulletedString, attributes: textAttributes)
            renderText(text: attributedString)
        }
    }
    
    func renderText(text attributedString: NSMutableAttributedString) {
        if currentOffset.y > printablePageRect.height {
            UIGraphicsBeginPDFPage()
            currentOffset.y = PDFCreator.margin
        }
        print("Render text current y offset: \(currentOffset.y)")
        
        let context = UIGraphicsGetCurrentContext()!
        
        let textMaxWidth = PDFCreator.pageRect.width - (2 * currentOffset.x)
        let textMaxHeight = PDFCreator.pageRect.height - (2 * currentOffset.y)
        var currentRange = CFRange(location: 0, length: 0)
  
        while (true) {
        
            context.saveGState()
            context.textMatrix = .identity
            context.translateBy(x: 0, y: PDFCreator.pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
        
            let frameRect = CGRect(x: PDFCreator.margin, y: currentOffset.y, width: textMaxWidth, height: textMaxHeight)
            let framePath = UIBezierPath(rect: frameRect).cgPath
        
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
    
        
            let frame = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
            CTFrameDraw(frame, context)
            context.restoreGState()
        
            let visibleRange = CTFrameGetVisibleStringRange(frame)
            currentRange = CFRange(location: visibleRange.location + visibleRange.length, length: 0)
        
            let constraintSize = CGSize(width: textMaxWidth, height: textMaxHeight)
            let drawnSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, visibleRange, nil, constraintSize, nil)
            
            currentOffset.y += drawnSize.height
            currentOffset.y += spacing

            if currentRange.location == CFAttributedStringGetLength(attributedString) {
                break
            } else {
                UIGraphicsBeginPDFPage()
                currentOffset.y = PDFCreator.margin
            }
        }
    }
    
    func renderImage(image: UIImage) {
        print("Current offset y for image: \(currentOffset.y)")
        
        let maxImageWidth: CGFloat = 300
        let maxImageHeight: CGFloat = 200
        
        let widthFactor = image.size.width / maxImageWidth
        let heightFactor = image.size.height / maxImageHeight

        let factor = max(widthFactor, heightFactor)
        let aspectWidth = image.size.width / factor
        let aspectHeight = image.size.height / factor
        
        let renderingXOffset: CGFloat = (PDFCreator.pageRect.width - aspectWidth) / 2
        
        let renderingRect = CGRect(x: renderingXOffset, y: currentOffset.y, width: aspectWidth, height: aspectHeight)
 
        image.draw(in: renderingRect)
        currentOffset.y = renderingRect.origin.y + renderingRect.height + spacing
        
        print("Image y origin: \(renderingRect.origin.y)")
        print("Image height: \(renderingRect.height)")
        print("Image y end: \(renderingRect.maxY)")
    }
    
    func addLineSeparator(height: CGFloat) {
        currentOffset.y += spacing
        let frameRect = CGRect(x: currentOffset.x + (PDFCreator.margin / 2), y: currentOffset.y, width: printablePageRect.width - PDFCreator.margin, height: height)
        
        let path = UIBezierPath(roundedRect: frameRect, cornerRadius: 8.0).cgPath
        
        let context = UIGraphicsGetCurrentContext()!
        
        UIColor.gray.setStroke()
        UIColor.gray.setFill()
        context.addPath(path)
        context.drawPath(using: .fillStroke)
        currentOffset.y += height + (spacing * 2)
        
    }
}
