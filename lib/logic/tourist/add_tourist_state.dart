
abstract class TouristState {}

class TouristInitial extends TouristState {}

class TouristLoading extends TouristState {}

class TouristSuccess extends TouristState {

}
/*class GetTourGuideSuccess extends TouristState {
  final List<TourGuideRequestBody> tourGuides;
  GetTourGuideSuccess({required this.tourGuides});

}*/

class TouristFailure extends TouristState {
  final String error;

  TouristFailure({required this.error});
}