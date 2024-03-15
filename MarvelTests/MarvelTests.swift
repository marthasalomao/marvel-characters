import XCTest
@testable import Marvel

class CharacterViewModelTests: XCTestCase {

    var viewModel: CharacterViewModel!
    
    override func setUp() {
        super.setUp()
        let mockService = MockMarvelAPIService()
        viewModel = CharacterViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCharactersSuccess() {
        let expectation = expectation(description: "Characters fetched successfully")
        
        viewModel.fetchCharactersIfNeeded()
        
        viewModel.delegate = self
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.allCharacters.count, 1)
    }
    
    func testFetchCharactersFailure() {
        let expectation = expectation(description: "Characters fetch failed")
        
        viewModel.fetchCharactersIfNeeded()
        
        viewModel.delegate = self
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.allCharacters.count, 0)
    }
    
    func testSearchCharacters() {
        let character1 = Character(id: 1, name: "Iron Man", description: nil, thumbnail: Thumbnail(path: "", fileExtension: ""), comics: ComicList(available: 0, collectionURI: "", items: []))
        let character2 = Character(id: 2, name: "Captain America", description: nil, thumbnail: Thumbnail(path: "", fileExtension: ""), comics: ComicList(available: 0, collectionURI: "", items: []))
        viewModel.allCharacters = [character1, character2]
        
        viewModel.searchCharacters(with: "Iron")
        
        XCTAssertEqual(viewModel.filteredCharacters.count, 1)
        XCTAssertEqual(viewModel.filteredCharacters.first?.name, "Iron Man")
    }
}

extension CharacterViewModelTests: CharacterViewModelDelegate {
    func didFetchCharactersSuccessfully(_ characters: [Character]) {
        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters.first?.name, "Iron Man")
    }
    
    func didFailToFetchCharacters(with error: Error) {
        XCTFail("Failed to fetch characters")
    }
    
    func didUpdateFilteredCharacters(_ characters: [Character]) {
        // No need to implement for this test
    }
}


