//
//  Recipe.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import Foundation
import UIKit

final class Recipe: Codable {
    
    var name: String
    var image: UIImage?
    var imageURL: URL?
    var cookTime: CookTime
    var cookingDifficulty: Difficulty
    var category: Category
    var description: String
    var ingredients: [String]
    var steps: [String]
    var author: String
    var isLiked: Bool?
    var wasUploaded: Bool?
    var localImageURL: URL?
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Category: String, CaseIterable, Codable {
        case american = "American"
        case cajun = "Cajun"
        case caribbean = "Caribbean"
        case chinese = "Chinese"
        case cuban = "Cuban"
        case dessert = "Dessert"
        case french = "French"
        case fusion = "Fusion"
        case german = "German"
        case greek = "Greek"
        case indian = "Indian"
        case japanese = "Japanese"
        case korean = "Korean"
        case italian = "Italian"
        case lebanese = "Lebanese"
        case mediterranean = "Mediterranean"
        case mexican = "Mexican"
        case moroccan = "Moroccan"
        case other = "Other"
        case peruvian = "Peruvian"
        case soul = "Soul"
        case spanish = "Spanish"
        case thai = "Thai"
        case turkish = "Turkish"
        case vietnamese = "Vietnamese"
    }
    
    enum CookTime: String, CaseIterable, Codable {
        case fifteen = "15 mins"
        case thirty = "30 mins"
        case fortyFive = "45 mins"
        case sixty = "1 hr"
        case oneHourFifteen = "1 hr 15 mins"
        case oneHourThirty = "1 hr 30 mins"
        case oneHourFortyFive = "1 hr 45 mins"
        case twoHours = "2 hrs"
        case twoHoursFifteen = "2 hrs 15 mins"
        case twoHoursThirty = "2 hrs 30 mins"
        case twoHoursFortyFive = "2 hrs 45 mins"
        case threeHours = "3 hrs"
        case threeHoursFifteen = "3 hrs 15 mins"
        case threeHoursThirty = "3 hrs 30 mins"
        case threeHoursFortyFive = "3 hrs 45 mins"
        case fourHours = "4 hrs"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case imageURL = "image_url"
        case cookTime
        case cookingDifficulty = "difficulty"
        case category
        case description
        case ingredients
        case steps
        case author
        case isLiked
        case wasUploaded
        case localImageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.cookTime = try container.decode(CookTime.self, forKey: CodingKeys.cookTime)
        self.cookingDifficulty = try container.decode(Difficulty.self, forKey: CodingKeys.cookingDifficulty)
        self.category = try container.decode(Category.self, forKey: CodingKeys.category)
        self.description = try container.decode(String.self, forKey: CodingKeys.description)
        self.ingredients = try container.decode([String].self, forKey: CodingKeys.ingredients)
        self.steps = try container.decode([String].self, forKey: CodingKeys.steps)
        self.imageURL = try? container.decode(URL.self, forKey: CodingKeys.imageURL)
        self.author = try container.decode(String.self, forKey: CodingKeys.author)
        
        self.isLiked = try? container.decode(Bool.self, forKey: CodingKeys.isLiked)
        self.wasUploaded = try? container.decode(Bool.self, forKey: CodingKeys.wasUploaded)
        
        self.localImageURL = try? container.decode(URL.self, forKey: CodingKeys.localImageURL)
    }
    
    init(name: String, image: UIImage, cookTime: CookTime, cookingDifficulty: Difficulty, category: Category, description: String, ingredients: [String], steps: [String], author: String) {
        self.name = name
        self.image = image
        self.cookTime = cookTime
        self.cookingDifficulty = cookingDifficulty
        self.category = category
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.author = author
    }
    
    // Sample recipes for development and testing
    static func loadSampleRecipes() -> [Recipe] {
        let macaronSteps = [
            "Make the macarons:",
            "In the bowl of a food processor, combine the powdered sugar, almond flour, and ½ teaspoon of salt, and process on low speed, until extra fine. Sift the almond flour mixture through a fine-mesh sieve into a large bowl",
            "In a separate large bowl, beat the egg whites and the remaining ½ teaspoon of salt with an electric hand mixer until soft peaks form.",
            "Gradually add the granulated sugar until fully incorporated. Continue to beat until stiff peaks form (you should be able to turn the bowl upside down without anything falling out)",
            "Add the vanilla and beat until incorporated. Add the food coloring and beat until just combined",
            "Add about 1/3 of the sifted almond flour mixture at a time to the beaten egg whites and use a spatula to gently fold until combined.",
            "After the last addition of almond flour, continue to fold slowly until the batter falls into ribbons and you can make a figure 8 while holding the spatula up",
            "Transfer the macaron batter into a piping bag fitted with a round tip",
            "Place 4 dots of the batter in each corner of a rimmed baking sheet, and place a piece of parchment paper over it, using the batter to help adhere the parchment to the baking sheet",
            "Pipe the macarons onto the parchment paper in 1½-inch (3-cm) circles, spacing at least 1-inch (2-cm) apart",
            "Tap the baking sheet on a flat surface 5 times to release any air bubbles",
            "Let the macarons sit at room temperature for 30 minutes to 1 hour, until dry to the touch",
            "Preheat the oven to 300˚F (150˚C)",
            "Bake the macarons for 17 minutes, until the feet are well-risen and the macarons don’t stick to the parchment paper",
            "Transfer the macarons to a wire rack to cool completely before filling",
            "Make the buttercream:",
            "In a large bowl, add the butter and beat with a mixer for 1 minute until light and fluffy.",
            "Sift in the powdered sugar and beat until fully incorporated.",
            "Add the vanilla and beat to combine.",
            "Add the cream, 1 tablespoon at a time, and beat to combine, until desired consistency is reached",
            "Transfer the buttercream to a piping bag fitted with a round tip",
            "Add a dollop of buttercream to one macaron shell.",
            "Top it with another macaron shell to create a sandwich. Repeat with remaining macaron shells and buttercream",
            "Place in an airtight container for 24 hours to \"bloom\"",
            "Enjoy!"
        ]
        
        let macaronIngredients = [
            "1 3/4 cups  powdered sugar",
            "1 cup  almond flour, finely ground",
            "1 teaspoon  salt, divided",
            "3 egg whites, at room temperature",
            "1/4 cup  granulated sugar",
            "1/2 teaspoon  vanilla extract",
            "2 drops pink gel food coloring",
            "1 cup  unsalted butter, 2 sticks, at room temperature",
            "3 cups  powdered sugar",
            "1 teaspoon  vanilla extract",
            "3 tablespoons  heavy cream"
        ]
        
        let macarons = Recipe(name: "Macarons", image: UIImage(named: "Macarons")!, cookTime: .sixty, cookingDifficulty: .hard, category: .dessert, description: "Lovely french macarons", ingredients: macaronIngredients, steps: macaronSteps, author: "johnsmith@example.com")
        
        let raspberryCheesecakeSteps = [
            "Preheat the oven to 350 degrees F",
            "To make the crust, combine the graham crackers, sugar, and melted butter until moistened.",
            "Pour into a 9-inch springform pan.",
            "With your hands, press the crumbs into the bottom of the pan and about 1-inch up the sides.",
            "Bake for 8 minutes. Cool to room temperature",
            "Raise the oven temperature to 450 degrees F",
            "To make the filling, cream the cream cheese and sugar in the bowl of an electric mixer fitted with a paddle attachment on medium-high speed until light and fluffy, about 5 minutes.",
            "Reduce the speed of the mixer to medium and add the eggs and egg yolks, 2 at a time, mixing well.",
            "Scrape down the bowl and beater, as necessary.",
            "With the mixer on low, add the sour cream, lemon zest, and vanilla.",
            "Mix thoroughly and pour into the cooled crust",
            "Bake for 15 minutes.",
            "Turn the oven temperature down to 225 degrees F and bake for another 1 hour and 15 minutes.",
            "Turn the oven off and open the door wide. The cake will not be completely set in the center.",
            "Allow the cake to sit in the oven with the door open for 30 minutes.",
            "Take the cake out of the oven and allow it to sit at room temperature for another 2 to 3 hours, until completely cooled.",
            "Wrap and refrigerate overnight",
            "Remove the cake from the springform pan by carefully running a hot knife around the outside of the cake.",
            "Leave the cake on the bottom of the springform pan for serving",
            "To make the topping, melt the jelly in a small pan over low heat.",
            "In a bowl, toss the raspberries and the warm jelly gently until well mixed.",
            "Arrange the berries on top of the cake. Refrigerate until ready to serve"
        ]
        
        let raspberryCheesecakeIngredients = [
            "1 1/2 cups graham cracker crumbs (10 crackers)",
            "1 tablespoon sugar",
            "6 tablespoons (3/4 stick) unsalted butter, melted",
            "2 1/2 pounds cream cheese, at room temperature",
            "1 1/2 cups sugar",
            "5 whole extra-large eggs, at room temperature",
            "2 extra-large egg yolks, at room temperature",
            "1/4 cup sour cream",
            "1 tablespoon grated lemon zest (2 lemons)",
            "1 1/2 teaspoons pure vanilla extract",
            "1 cup red jelly (not jam), such as currant, raspberry, or strawberry",
            "3 half-pints fresh raspberries"
        ]
        
        let raspberryCheesecake = Recipe(name: "Raspberry Cheesecake", image: UIImage(named: "RaspberryCheesecake")!, cookTime: .twoHours, cookingDifficulty: .medium, category: .dessert, description: "Classic raspberry cheesecake", ingredients: raspberryCheesecakeIngredients, steps: raspberryCheesecakeSteps, author: "johnsmith@example.com")
        
        let cherryPieSteps = [
            "In a large saucepan, combine sugar and cornstarch.",
            "Gradually stir in cherry juice until smooth.",
            "Bring to a boil; cook and stir for 2 minutes or until thickened.",
            "Remove from the heat.",
            "Add the cherries, cinnamon, nutmeg and extract; set aside",
            "In a large bowl, combine flour and salt; cut in shortening until crumbly.",
            "Gradually add cold water, tossing with a fork until a ball forms.",
            "Divide dough in half so that one ball is slightly larger than the other",
            "On a lightly floured surface, roll out larger ball to fit a 9-in. pie plate.",
            "Transfer dough to pie plate; trim even with edge of plate.",
            "Add filling. Roll out remaining dough; make a lattice crust. Trim, seal and flute edges",
            "Bake at 425° for 10 minutes.",
            "Reduce heat to 375°; bake 45-50 minutes longer or until crust is golden brown.",
            "Cool on a wire rack"
        ]
        
        let cherryPieIngredients = [
            "1 1/4 cups sugar",
            "1/3 cup cornstarch",
            "1 cup cherry juice blend",
            "4 cups fresh tart cherries, pitted or frozen pitted tart cherries, thawed",
            "1/2 teaspoon ground cinnamon",
            "1/4 teaspoon ground nutmeg",
            "1/4 teaspoon almond extract",
            "2 cups all-purpose flour",
            "1/2 teaspoon salt",
            "2/3 cup shortening",
            "5 to 7 tablespoons cold water"
        ]
        
        let cherryPie = Recipe(name: "Cherry Pie", image: UIImage(named: "CherryPie")!, cookTime: .oneHourFifteen, cookingDifficulty: .easy, category: .dessert, description: "Home-cooked apple pie!", ingredients: cherryPieIngredients, steps: cherryPieSteps, author: "johnsmith@example.com")
        
        let tiramisuSteps = [
            "Using an electric mixer in a medium bowl, whip together egg yolks and 1/4 cup/50 grams sugar until very pale yellow and about tripled in volume.",
            "A slight ribbon should fall from the beaters (or whisk attachment) when lifted from the bowl.",
            "Transfer mixture to a large bowl, wiping out the medium bowl used to whip the yolks and set aside",
            "In the medium bowl, whip cream and remaining 1/4 cup sugar until it creates soft-medium peaks.",
            "Add mascarpone and continue to whip until it creates a soft, spreadable mixture with medium peaks.",
            "Gently fold the mascarpone mixture into the sweetened egg yolks until combined",
            "Combine espresso and rum in a shallow bowl and set aside",
            "Using a sifter, dust the bottom of a 2-quart baking dish (an 8x8-inch dish, or a 9-inch round cake pan would also work here) with 1 tablespoon cocoa powder",
            "Working one at a time, quickly dip each ladyfinger into the espresso mixture -- they are quite porous and will fall apart if left in the liquid too long -- and place them rounded side up at the bottom of the baking dish.",
            "Repeat, using half the ladyfingers, until you’ve got an even layer, breaking the ladyfingers in half as needed to fill in any obvious gaps (a little space in between is O.K.).",
            "Spread half the mascarpone mixture onto the ladyfingers in one even layer.",
            "Repeat with remaining espresso-dipped ladyfingers and mascarpone mixture",
            "Dust top layer with remaining tablespoon of cocoa powder.",
            "Top with shaved or finely grated chocolate, if desired",
            "Cover with plastic wrap and let chill in the refrigerator for at least 4 hours (if you can wait 24 hours, all the better) before slicing or scooping to serve"
        ]
        
        let tiramisuIngredients = [
            "4 large egg yolks",
            "1/2 cup granulated sugar, divided",
            "3/4 cup heavy cream",
            "1 cup mascarpone (8 ounces)",
            "1 3/4 cups good espresso or very strong coffee",
            "2 tablespoons rum or cognac",
            "2 tablespoons unsweetened cocoa powder",
            "About 24 ladyfingers (from one 7-ounce package)",
            "1 to 2 ounces bittersweet chocolate, for shaving (optional)"
        ]
        
        let tiramisu = Recipe(name: "Tiramisu", image: UIImage(named: "Tiramisu")!, cookTime: .fortyFive, cookingDifficulty: .hard, category: .dessert, description: "Italian tiramisu", ingredients: tiramisuIngredients, steps: tiramisuSteps, author: "johnsmith@example.com")
        
        let birthdayCakeFudgeSteps = [
            "Line a 8x8- or 9x9-inch pan with parchment paper",
            "In a large bowl, stir together sweetened condensed milk and cake mix until combined.",
            "Fold in melted chocolate.",
            "Gently fold in cup of sprinkles",
            "Pour mixture into prepared pan and smooth top with an offset spatula.",
            "Top with remaining cup sprinkles and gently press into fudge",
            "Refrigerate until firm, about 2 hours",
            "Cut into 16 pieces and serve"
        ]
        
        let birthdayCakeFudgeIngredients = [
            "1 (14-oz.) can sweetened condensed milk",
            "1/2 cup yellow or Funfetti cake mix",
            "2 cup white chocolate chips, melted",
            "1/2 c. confetti rainbow sprinkles, divided"
        ]
        
        let birthdayCakeFudge = Recipe(name: "Birthday Cake Fudge", image: UIImage(named: "BirthdayCakeFudge")!, cookTime: .twoHoursThirty, cookingDifficulty: .easy, category: .dessert, description: "An interesting take on fudge", ingredients: birthdayCakeFudgeIngredients, steps: birthdayCakeFudgeSteps, author: "johnsmith@example.com")
        
        return [macarons, raspberryCheesecake, cherryPie, tiramisu, birthdayCakeFudge]
    }
}
