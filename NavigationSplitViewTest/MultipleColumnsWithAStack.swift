//
//  MultipleColumnsWithAStack.swift
//  NavigationSplitViewTest
//
//  Created by sako0602 on 2023/04/16.
//

import SwiftUI

struct MultipleColumnsWithAStack: View {
    
    @State private var selectedCategory: Category?
    @State private var selectedRecipe: Recipe?
    @State private var dataModel = DataModel()
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var path: [Recipe] = []
    
    var body: some View {
        NavigationSplitView {
            //カテゴリーリスト
            List(Category.allCases, selection: $selectedCategory){ category in
                NavigationLink(category.localizedName, value: category)
            }
            .navigationTitle("カテゴリー")
        } detail: {
            //レシピの詳細ビュー
            NavigationStack(path: $path) {
                RecipeGrid(category: selectedCategory)
            }
        }
        .environmentObject(dataModel)
    }
}

struct RecipeGrid: View {
    
    @EnvironmentObject private var dataMdole: DataModel
    var category: Category?
    
    var body: some View {
        if let category = category {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(dataMdole.recipes(in: category)){ recipe in
                        NavigationLink(value: recipe) {
                            RecipeTitle(recipe: recipe)
                        }
                       //🟥ここに.navigaitonDestinationを書くのは厳禁。全部のアイテムに対して定期用されてしまう。
                    }
                }
            }
            .navigationTitle(category.localizedName)
            //🟦.navigationDestinationの記述箇所に注意。
            //ListやLazyVGridのようなレイジーコンテナはビューをすぐにロードしない。結果、遷移先にロードされない場合がある。
            //NavigationStackが認識しない可能性がある。
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetail2(recipe: recipe)
            }
        }
    }
    var columns: [GridItem] { [GridItem(.adaptive(minimum: 240))] }
}

struct RecipeTitle: View {
    
    var recipe: Recipe
    
    var body: some View{
        VStack {
            Rectangle()
                .fill(Color.secondary.gradient)
                .frame(width: 240, height: 240)
            Text(recipe.name)
                .lineLimit(2, reservesSpace: true)
                .font(.headline)
        }
        .tint(.primary)
    }
}

struct RecipeDetail2: View {
    @EnvironmentObject private var dataModel: DataModel
    var recipe: Recipe

    var body: some View {
        Text("Recipe details go here")
            .navigationTitle(recipe.name)
        ForEach(recipe.related.compactMap { dataModel[$0] }) { related in
            NavigationLink(related.name, value: related)
        }
    }
}

struct MultipleColumnsWithAStack_Previews: PreviewProvider {
    static var previews: some View {
        MultipleColumnsWithAStack()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
