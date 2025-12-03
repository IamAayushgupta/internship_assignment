import 'package:flutter/material.dart';
import '../main.dart';
import '../models/home_response.dart';
import '../services/api_service.dart';
import '../widgets/header_section.dart';
import '../widgets/continue_watching_carousel.dart';
import '../widgets/yoga_category_grid.dart';
import '../widgets/popular_videos_list.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeResponse> _homeDataFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = ApiService.fetchHomeData('randomstring');
  }

  Widget _buildHomeContent(HomeResponse data) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(header: data.header),
            const SizedBox(height: 24),
            ContinueWatchingCarousel(
              continueWatching: data.continueWatching,
            ),
            const SizedBox(height: 32),
            YogaCategoryGrid(
              yogaCategories: data.yogaCategories,
            ),
            const SizedBox(height: 32),
            PopularVideosList(
              popularVideos: data.popularVideos,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityContent(HomeResponse data) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Activity',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            PopularVideosList(
              popularVideos: data.popularVideos,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HomeResponse>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _homeDataFuture = ApiService.fetchHomeData('randomstring');
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          final data = snapshot.data!;

          // Show different content based on selected tab
          if (_currentIndex == 1) {
            return _buildActivityContent(data);
          }

          return _buildHomeContent(data);
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}