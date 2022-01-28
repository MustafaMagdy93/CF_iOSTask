
import Foundation

protocol TestAPIProtocol {
    func getPopularMovies(completion: @escaping (Result<PopularMoviesResponse?, GFError>) -> Void)
    func getMovieDetails(completion: @escaping (Result<MovieDetailsResponse?, GFError>) -> Void)
    func getReviews(completion: @escaping (Result<GetReviewsResponse?, GFError>) -> Void)

}


class TestAPI: BaseAPI<TestNetworking>, TestAPIProtocol {
    
    static let shared: TestAPIProtocol = TestAPI()
    
    //MARK:- Requests
    
    func getPopularMovies(completion: @escaping (Result<PopularMoviesResponse?, GFError>) -> Void) {
        self.fetchData(target: .getPopularMovies, responseClass: PopularMoviesResponse.self) { (result) in
            completion(result)
        }
    }
    
    func getMovieDetails(completion: @escaping (Result<MovieDetailsResponse?, GFError>) -> Void) {
        self.fetchData(target: .getMovieDetails, responseClass: MovieDetailsResponse.self) { (result) in
            completion(result)
        }

    }
    
    func getReviews(completion: @escaping (Result<GetReviewsResponse?, GFError>) -> Void) {
        self.fetchData(target: .getReviews, responseClass: GetReviewsResponse.self) { (result) in
            completion(result)
        }

    }


}
