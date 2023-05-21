//
//  PlanetsListView.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 09/05/23.
//

import SwiftUI

struct PlanetsListView<Model>: View where Model: PlanetsViewModelInterface {
    @ObservedObject private var viewModel: Model
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        LoadingView(isShowing: .constant(viewModel.loading == .requesting))  {
            List(viewModel.planets) { item in
                Text(item.name).foregroundColor(Color.Text.charcoal).listRowBackground(Color.Background.white)
            }}
        .onAppear {
            self.viewModel.onViewDidLoad()
        } .navigationBarTitle(viewModel.screenTitle)
            .alert(isPresented: .constant(viewModel.error != nil)) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.error ?? ""), dismissButton: .default(Text("Got it!")))
            }
    }
}


#if DEBUG
struct MoviesQueryListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsListView(viewModel: PlanetsViewModelMock())
    }
}
#endif
