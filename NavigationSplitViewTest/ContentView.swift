//
//  ContentView.swift
//  NavigationSplitViewTest
//
//  Created by sako0602 on 2023/04/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCategory: Category?
    @State private var selectedRecipe: Recipe?
//    @State private var aaa: [Category] = [
//        Category.dessert,
//        Category.pancake
//    ]
    @State private var dataModel = DataModel()
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    //🟦navigationDestinationモディファイア不要
    var body: some View { //(columnVisibility: $columnVisibility)
        NavigationSplitView {
            //カテゴリーリスト
            //Categoryの配列、selectionはListに表示された
            List(Category.allCases, selection: $selectedCategory){ category in
                NavigationLink(category.localizedName, value: category)
            }
            //カラムを全てスクリーンアウトさせる
//            Button {
//                columnVisibility = .detailOnly
//            } label: {
//                Text("詳細Viewのみにする")
//            }
            .navigationTitle("カテゴリー")
        } content: {
            //レシピリスト
            List(dataModel.recipes(in: selectedCategory), selection: $selectedRecipe) { recipe in
                NavigationLink(recipe.name, value: recipe)
//                let _ = print(">>>", recipe)
            }
            .navigationTitle(selectedCategory?.localizedName ?? "レシピ")
        } detail: {
            //レシピの詳細ビュー
            RecipeDetail(recipe: selectedRecipe)
        }
    }
}

// Helpers for code example
struct RecipeDetail: View {
    var recipe: Recipe?

    var body: some View {
        Text("Recipe details go here")
            .navigationTitle(recipe?.name ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
