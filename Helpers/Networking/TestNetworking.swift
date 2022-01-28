
import Foundation
import Alamofire

enum TestNetworking {
    case getPopularMovies
    case getMovieDetails
    case getReviews
}

extension TestNetworking: TargetType {
    var baseURL: String {
        switch self {
        default:
            return "https://api.themoviedb.org/3"
        }
    }
    
    var path: String {
        switch self {
        case .getPopularMovies:
            return "/movie/popular?api_key=91187c425387f71232ab547b004c3216&language=en-US&page=1"
        case .getMovieDetails:
            return "/movie/\(HomeVC.movieId ?? 0)?api_key=91187c425387f71232ab547b004c3216&language=en-US"
        case .getReviews:
            return "/movie/\(HomeVC.movieId ?? 0)/reviews?api_key=91187c425387f71232ab547b004c3216&language=en-US&page=1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPopularMovies, .getMovieDetails, .getReviews:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies, .getMovieDetails, .getReviews:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
