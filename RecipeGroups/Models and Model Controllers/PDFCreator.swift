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
    var currentOffset = CGPoint(x: 0, y: PDFCreator.margin + 10)
    
    // Returns PDF as Data, which can be shown in a PDFKit PDFViewer
    func createPDFFromRecipe(recipe: Recipe) -> Data {
        currentOffset = CGPoint(x: 0, y: PDFCreator.margin)
        let renderer = UIGraphicsPDFRenderer(bounds: PDFCreator.pageRect)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            addRecipeTitle(title: recipe.name)
            addImage(fromRecipe: recipe)
            addRecipeDescription(description: recipe.description)
            
            addLineSeparator(height: 0.5)
            addSectionTitle(title: "Ingredients:")
            addBulletedText(text: recipe.ingredients)
            addLineSeparator(height: 0.5)
            addSectionTitle(title: "Steps:")
            addBulletedText(text: recipe.steps)
        }
        
        return data
    }
    
    func addRecipeTitle(title: String) {
        
        let defaultFont: UIFont = .systemFont(ofSize: 26.0)
        let font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 26.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: title, attributes: textAttributes)
        
        renderText(text: attributedString)
    }
    
    func addSectionTitle(title: String) {
        
        let defaultFont: UIFont = .systemFont(ofSize: 12.0)
        
        
        let font = UIFont(name: CustomStyles.shared.customFontNameWide, size: 12.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: title, attributes: textAttributes)
        
        renderText(text: attributedString)
    }
    
    func addImage(fromRecipe recipe: Recipe) {
        guard let image = recipe.image else { return }
        renderImage(image: image)
    }
    
    func addRecipeDescription(description: String) {
        
        // Setting the string settings
        let defaultFont: UIFont = .systemFont(ofSize: 16.0)
        let font = UIFont(name: CustomStyles.shared.customFontName, size: 16.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: description, attributes: textAttributes)
        
        renderText(text: attributedString)
    }
    
    func addBulletedText(text: [String]) {
        
        // Setting the font and string settings
        let defaultFont: UIFont = .systemFont(ofSize: 12.0)
        let font = UIFont(name: CustomStyles.shared.customFontName, size: 12.0) ?? defaultFont
        let color = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let bullet: String = "\u{2022}"
        
        for i in 0...text.count - 1 {
            let bulletedString = "\(bullet)   \(text[i])"
            let attributedString = NSMutableAttributedString(string: bulletedString, attributes: textAttributes)
            renderText(text: attributedString)
        }
        
    }
    
    func renderText(text attributedString: NSMutableAttributedString) {
        // Check if current drawing point is past the printable page area
        if currentOffset.y > printablePageRect.height {
            UIGraphicsBeginPDFPage()
            currentOffset.y = PDFCreator.margin
        }
        
        // Get the current range and graphics context
        let context = UIGraphicsGetCurrentContext()!
        var currentRange = CFRange(location: 0, length: 0)
  
        while (true) {
            
            let textMaxWidth = printablePageRect.width
            var textMaxHeight = PDFCreator.pageRect.height - currentOffset.y
            var currentYCoordinate = PDFCreator.pageRect.height - currentOffset.y
            
            context.saveGState()
            context.textMatrix = .identity
            context.translateBy(x: 0, y: PDFCreator.pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            var frameRect = CGRect(x: PDFCreator.margin, y: currentYCoordinate, width: textMaxWidth, height: textMaxHeight)
            var framePath = UIBezierPath(rect: frameRect).cgPath
        
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
    
            var frame = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
            let visibleRange = CTFrameGetVisibleStringRange(frame)
            
            currentRange = CFRange(location: visibleRange.location, length: visibleRange.length)
        
            let constraintSize = CGSize(width: textMaxWidth, height: textMaxHeight)
            let drawnSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, visibleRange, nil, constraintSize, nil)
            
            // If the suggested frame size is greater than the area left on the current page, begin a new pdf page
            if drawnSize.height < textMaxHeight {
                textMaxHeight = drawnSize.height
                currentOffset.y += textMaxHeight
                currentYCoordinate = PDFCreator.pageRect.height - currentOffset.y
            } else {
                textMaxHeight = drawnSize.height
                currentOffset.y = PDFCreator.margin + spacing
                currentYCoordinate = PDFCreator.pageRect.height - currentOffset.y
                UIGraphicsBeginPDFPage()
            }

            frameRect = CGRect(x: PDFCreator.margin, y: currentYCoordinate, width: textMaxWidth, height: textMaxHeight)
            framePath = UIBezierPath(rect: frameRect).cgPath
            frame = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
            
            CTFrameDraw(frame, context)
            context.restoreGState()
            currentOffset.y += spacing
            
            if currentRange.location <= CFAttributedStringGetLength(attributedString) {
                return
            } else {
                UIGraphicsBeginPDFPage()
                currentOffset.y = PDFCreator.margin
            }
        }
    }
    
    func renderImage(image: UIImage) {
        
        let maxImageWidth: CGFloat = 300
        let maxImageHeight: CGFloat = 200
        
        let widthFactor = image.size.width / maxImageWidth
        let heightFactor = image.size.height / maxImageHeight

        let factor = max(widthFactor, heightFactor)
        let aspectWidth = image.size.width / factor
        let aspectHeight = image.size.height / factor
        
        let renderingXOffset: CGFloat = (PDFCreator.pageRect.width - aspectWidth) / 2
        
        let renderingRect = CGRect(x: renderingXOffset, y: currentOffset.y + spacing, width: aspectWidth, height: aspectHeight)
 
        image.draw(in: renderingRect)
        currentOffset.y = renderingRect.origin.y + renderingRect.height + spacing
    }
    
    func addLineSeparator(height: CGFloat) {
        currentOffset.y += spacing
        let frameRect = CGRect(x: currentOffset.x + PDFCreator.margin, y: currentOffset.y, width: printablePageRect.width, height: height)
        
        let path = UIBezierPath(roundedRect: frameRect, cornerRadius: 8.0).cgPath
        
        let context = UIGraphicsGetCurrentContext()!
        
        UIColor.gray.setStroke()
        UIColor.gray.setFill()
        context.addPath(path)
        context.drawPath(using: .fillStroke)
        currentOffset.y += height + (spacing * 2)
    }
}
