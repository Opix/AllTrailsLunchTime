//
//  ActionView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/27/21.
//

import SwiftUI

struct ActionView: View {
    @Binding var sortEnabled: Bool
    @Binding var filterEnabled: Bool
    @Binding private var searchText: String
    var searchTapped: () -> Void
    @State private var showSortActionSheet: Bool = false
    @State private var showFilterActionSheet: Bool = false
    var sort: (_ by: SortOptions) -> Void
    var filter: (_ by: FilterOptions) -> Void

    @Binding var currentSort: SortOptions
    @Binding var currentFilter: FilterOptions

    public init(sortEnabled: Binding<Bool>,
                currentSort: Binding<SortOptions>,
                filterEnabled: Binding<Bool>,
                currentFilter: Binding<FilterOptions>,
                searchText: Binding<String>,
                searchTapped: @escaping() -> Void,
                sort: @escaping(_ by: SortOptions) -> Void,
                filter: @escaping(_ by: FilterOptions) -> Void) {
        self._sortEnabled = sortEnabled
        self._filterEnabled = filterEnabled
        self._searchText = searchText
        self.searchTapped = searchTapped
        self.sort = sort
        self.filter = filter
        self._currentSort = currentSort
        self._currentFilter = currentFilter
    }
    
    var body: some View {
        HStack (alignment: .center) {
            ZStack {
                TextField("Search for a restaurant", text: $searchText,
                    // This is triggered when return key is pressed.
                    onCommit: {
                        if !searchText.isEmpty {
                            self.hideKeyboard()
                            self.searchTapped()
                        }
                    })
                    .padding(8)
                    .multilineTextAlignment(.leading)
                    .overlay(RoundedRectangle(cornerRadius: kCornerRadius / 2).stroke(Color(UIColor.systemGray4), lineWidth: kBorderLineWidth))
                    .shadow(radius: kCornerRadius)
                
                // overlay above seems to be covering this button and therefore becomes non-responsive to tapping.  So place this above the text.
                HStack {
                    Spacer()
                    Button (action: {
                        if !searchText.isEmpty {
                            self.searchTapped()
                        }
                        }) {
                        Image("search")
                            .foregroundColor(appPrimaryColor)
                    }
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(kHalfPadding)
                }
            }
            
            Button(action: {
                self.hideKeyboard()
                showFilterActionSheet = true
            }) {
                Image("filter").foregroundColor(appPrimaryColor)
            }
            .frame(width: 40, height: 40, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: kCornerRadius / 2).stroke(Color(UIColor.systemGray4), lineWidth: kBorderLineWidth))
            .shadow(radius: kCornerRadius)
            .actionSheet(isPresented: $showFilterActionSheet) {
                generateFilterActionSheet()
            }.if(filterEnabled) { $0.foregroundColor(appPrimaryColor) } else: { $0.foregroundColor(Color(UIColor.systemGray2)) }
            .disabled(!filterEnabled)
            
            Button(action: {
                self.hideKeyboard()
                showSortActionSheet = true
            }) {
                Image("sort").foregroundColor(sortEnabled ? appPrimaryColor : Color(UIColor.systemGray2))
            }
            .frame(width: 40, height: 40, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: kCornerRadius / 2).stroke(Color(UIColor.systemGray4), lineWidth: kBorderLineWidth))
            .shadow(radius: kCornerRadius)
            // Note: confirmationDialog for iOS 15 or later
            .actionSheet(isPresented: $showSortActionSheet) {
                generateSortActionSheet()
            }.if(sortEnabled) { $0.foregroundColor(appPrimaryColor) } else: { $0.foregroundColor(Color(UIColor.systemGray2)) }
            .disabled(!sortEnabled)
        }.padding(.horizontal, kDefaultPadding)
    }
    
    private func generateSortActionSheet() -> ActionSheet {
        let buttons = SortOptions.allCases.enumerated().map { i, option in
            Alert.Button.default(currentSort == option ? Text("\(option.title) ✔️") : Text(option.title),
                action: { self.sort(option) } )
        }
        return ActionSheet(title: Text("Sort By"),
                   buttons: buttons + [Alert.Button.cancel()])
    }
    
    private func generateFilterActionSheet() -> ActionSheet {
        let buttons = FilterOptions.allCases.enumerated().map { i, option in
            Alert.Button.default(currentFilter == option ? Text("\(option.title) ✔️") : Text(option.title),
                action: { self.filter(option) } )
        }
        return ActionSheet(title: Text("Filter By"),
                   buttons: buttons + [Alert.Button.cancel()])
    }
}
