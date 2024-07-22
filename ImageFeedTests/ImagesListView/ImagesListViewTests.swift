@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        XCTAssertFalse(presenter.viewDidLoadCalled)
        _ = vc.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewPresenterCallsFetchPhotosNextPage() {
        //given
        let vc = ImagesListViewControllerSpy()
        let imagesListServiceMock = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListServiceMock)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        XCTAssertFalse(imagesListServiceMock.fetchPhotosNextPageCalled)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListServiceMock.fetchPhotosNextPageCalled)
    }
    
    func testFormatDate() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        let mockDateString = "2024-07-02 16:19:28 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: mockDateString)!
        let dateString = presenter.formattedDate(from: date)
        
        //then
        XCTAssertEqual("2 Jul 2024", dateString)
    }
    
    
}
