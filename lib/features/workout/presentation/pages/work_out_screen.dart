import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker_app/core/navigation_services.dart';
import 'package:gym_tracker_app/features/workout/presentation/cubit/workout_cubit.dart';
import 'package:gym_tracker_app/features/workout/presentation/cubit/workout_state.dart';
import 'package:gym_tracker_app/features/workout/presentation/widgets/body_part_dropdown.dart';
import 'package:gym_tracker_app/features/workout/presentation/widgets/youtube_player.dart';

class WorkOutScreen extends StatefulWidget {
  const WorkOutScreen({super.key});

  @override
  State<WorkOutScreen> createState() => _WorkOutScreenState();
}

class _WorkOutScreenState extends State<WorkOutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutCubit>().fetchWorkList(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutCubit, WorkOutState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: const Text(
              'Workouts',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          body: Column(
            children: [
              BodyPartDropdown(state: state),
              DifficultyDropdown(state: state),
              Expanded(
                // Add Expanded to allow the ListView to take remaining space
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: state.isLoadingState
                      ? const Center(child: CircularProgressIndicator.adaptive())
                      : (state.workOutList ?? []).isEmpty
                          ? const Center(
                              child: Text(
                                'No Data',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling is always possible
                              itemCount: (state.workOutList ?? []).length,
                              itemBuilder: (c, i) {
                                var item = state.workOutList?[i];
                                return GestureDetector(
                                  child: _buildWorkoutCard(
                                    title: item?.name ?? 'N/A',
                                    bodyPart: item?.bodyPart ?? 'N/A',
                                    difficulty: item?.difficulty ?? 'N/A',
                                    imageUrl: item?.videoUrl ?? 'N/A',
                                  ),
                                  onTap: () {
                                    navigateTo(
                                        context: context,
                                        screen: SimpleYoutubePlayer(
                                          youtubeUrl: item?.videoUrl ?? '',
                                          description: item?.instructions ?? 'N/A',
                                        ));
                                  },
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutCard({
    required String title,
    required String bodyPart,
    required String difficulty,
    required String imageUrl,
  }) {
    // var image = 'https://hips.hearstapps.com/hmg-prod/images/young-muscular-build-athlete-exercising-strength-in-royalty-free-image-1706546541.jpg?crop=1.00xw:0.752xh;0,0.142xh&resize=1200:*';
    var image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1bLxtD1q5ZJacTxz_Kn0PS9wYhLqzIkBItQ&s";
    return Card(
      color: Colors.black, // Dark theme background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade700, width: 2), // Border
      ),
      elevation: 5, // Shadow for depth
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                  ),
                );
              },
              errorBuilder: (context, _, __) => const Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for dark theme
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      bodyPart,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.terrain, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(
                      difficulty,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
