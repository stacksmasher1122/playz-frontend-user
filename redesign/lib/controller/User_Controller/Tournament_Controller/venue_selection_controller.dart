import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/User_Models/Tournament_Model/venue_model.dart';
import '../../../view/USER/Tournament/format_setup/format_setup_page.dart';
import '../../../view/USER/Maps/maps_picker/maps_picker_screen.dart';
import '../../../model/maps_model.dart';
import '../../../controller/maps_controller.dart';

class VenueSelectionController extends GetxController {
  final RxList<VenueModel> venues = <VenueModel>[].obs;
  final RxList<VenueModel> filteredVenues = <VenueModel>[].obs;
  
  final RxString selectedTab = "PlayZ Venues".obs;
  final RxString selectedFilter = "Nearby".obs;
  
  final TextEditingController searchController = TextEditingController();
  
  final List<String> availableFilters = [
    "Nearby",
    "Football 5v5",
    "Indoor",
    "Rated 4.5+",
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDummyVenues();
    
    searchController.addListener(() {
      searchVenue(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadDummyVenues() {
    final dummyData = [
      VenueModel(
        id: "1",
        name: "Urban Arena Hub",
        image: "https://via.placeholder.com/150", // In a real app, use asset or valid network image
        distance: 2.4,
        rating: 4.8,
        reviewCount: 124,
        isIndoor: false,
        category: "Football 5v5",
        location: "Seattle",
      ),
      VenueModel(
        id: "2",
        name: "City Sportsplex",
        image: "https://via.placeholder.com/150",
        distance: 3.1,
        rating: 4.9,
        reviewCount: 89,
        isIndoor: true,
        category: "Football 5v5",
        location: "Seattle",
      ),
      VenueModel(
        id: "3",
        name: "Metro Pitch",
        image: "https://via.placeholder.com/150",
        distance: 5.0,
        rating: 4.2,
        reviewCount: 45,
        isIndoor: false,
        category: "Football 7v7",
        location: "Seattle",
      ),
    ];
    
    venues.assignAll(dummyData);
    filteredVenues.assignAll(venues);
  }


  void changeTab(String tab) {
    selectedTab.value = tab;
    _applyFilters();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void _applyFilters() {
    String query = searchController.text.toLowerCase();
    
    List<VenueModel> result = venues.where((venue) {
      bool matchesSearch = venue.name.toLowerCase().contains(query) || 
                           venue.location.toLowerCase().contains(query);
      
      bool matchesTab = true;
      if (selectedTab.value == "PlayZ Venues") {
        // Dummy logic: let's say rating >= 4.5 is PlayZ Verified
        matchesTab = venue.rating >= 4.5;
      } else {
        matchesTab = venue.rating < 4.5;
      }

      bool matchesFilter = true;
      if (selectedFilter.value == "Football 5v5") {
        matchesFilter = venue.category == "Football 5v5";
      } else if (selectedFilter.value == "Indoor") {
        matchesFilter = venue.isIndoor;
      } else if (selectedFilter.value == "Rated 4.5+") {
        matchesFilter = venue.rating >= 4.5;
      } else if (selectedFilter.value == "Nearby") {
        matchesFilter = venue.distance <= 5.0;
      }

      return matchesSearch && matchesTab && matchesFilter;
    }).toList();

    filteredVenues.assignAll(result);
  }

  final Rx<double?> selectedVenueLatitude = Rx<double?>(null);
  final Rx<double?> selectedVenueLongitude = Rx<double?>(null);
  final Rx<String?> selectedVenueAddress = Rx<String?>(null);
  final Rx<String?> selectedVenueName = Rx<String?>(null);

  Future<void> onLocationTap(BuildContext context) async {
    final result = await Navigator.push<LocationData>(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(isSelectOnly: true),
      ),
    );

    if (result != null) {
      selectedVenueLatitude.value = result.lat;
      selectedVenueLongitude.value = result.lng;
      selectedVenueAddress.value = result.fullAddress;
      selectedVenueName.value = result.landmark.isNotEmpty ? result.landmark : (result.subLocality.isNotEmpty ? result.subLocality : result.city);

      // We found a location from MapPicker, make sure it reflects in "Other Venue" model
      // Usually "Other Venue" doesn't have a static list to select from,
      // but we should store it in the controller for the final model
      searchController.text = result.fullAddress;
      selectedTab.value = "Other Venue";
    }
  }

  void selectVenue(String id) {
    for (int i = 0; i < venues.length; i++) {
      if (venues[i].id == id) {
        venues[i].isSelected = true;
        selectedVenueLatitude.value = venues[i].latitude;
        selectedVenueLongitude.value = venues[i].longitude;
        selectedVenueAddress.value = venues[i].fullAddress;
        selectedVenueName.value = venues[i].name;
      } else {
        venues[i].isSelected = false;
      }
    }
    venues.refresh();
    _applyFilters();
  }

  void searchVenue(String query) {
    _applyFilters();
  }

  void goNext(BuildContext context) {
    // Temporarily removed validation to allow easier UI testing navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormatSetupPage()),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
