import 'package:dio/dio.dart';
import 'package:gym_tracker_app/features/workout/data/models/work_out_model.dart';

class WorkOutRemoteDatasource {
  final Dio dio;

  WorkOutRemoteDatasource({required this.dio});

  /// Signs up a user
  Future<List<WorkOutModel>> workOuts() async {
    try {
      return workOutList;
      // var response = await dio.get(
      //   APIEndPoints.workOutsUrl,
      // );
      // if (response.statusCode == 400 || response.statusCode == 401) throw Exception(response.data['error']);
      // final responseData = response.data as List<dynamic>;
      // return responseData.map((json) => WorkOutModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Logs in a user
}

final List<WorkOutModel> workOutList = [
  const WorkOutModel(
    bodyPart: 'Chest',
    difficulty: 'Easy',
    equipment: 'Dumbbell',
    id: '1',
    instructions:
        'Perform 4 sets of 8-12 reps each of flat bench press, incline dumbbell press, chest flyes, and push-ups with 60-second rest between sets, focusing on full range of motion and chest contraction.',
    name: 'Chest Easy Workout',
    videoUrl: 'https://www.youtube.com/watch?v=KIl70ffF5FM&pp=ygUdY2hlc3Qgd29ya291dCB1c2luZyBkdW1iYmVsbHM%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Back',
    difficulty: 'Medium',
    equipment: 'Barbell',
    id: '2',
    instructions:
        'Complete 4 sets of 10 reps of deadlifts, bent-over rows, lat pulldowns, and seated cable rows with 90-second rest between sets, maintaining proper form and engaging your lats throughout each movement.',
    name: 'Back Builder Workout',
    videoUrl: 'https://www.youtube.com/watch?v=NUVo0XDd4oc&pp=ygUdY2hlc3Qgd29ya291dCB1c2luZyBkdW1iYmVsbHM%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Legs',
    difficulty: 'Hard',
    equipment: 'Barbell',
    id: '3',
    instructions:
        'Perform 5 sets of 6-8 reps of squats, Romanian deadlifts, lunges, and leg press with 2-minute rest periods, focusing on progressive overload and maintaining tension in your quads, hamstrings and glutes.',
    name: 'Intense Leg Day',
    videoUrl: 'https://www.youtube.com/watch?v=KIl70ffF5FM&pp=ygUdY2hlc3Qgd29ya291dCB1c2luZyBkdW1iYmVsbHM%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Shoulders',
    difficulty: 'Medium',
    equipment: 'Dumbbell',
    id: '4',
    instructions:
        'Complete 4 sets of 10-12 reps of overhead press, lateral raises, front raises, and rear delt flyes with 60-second rest between exercises, focusing on controlled movements and full shoulder engagement.',
    name: 'Shoulder Sculptor',
    videoUrl: 'https://www.youtube.com/watch?v=NUVo0XDd4oc&pp=ygUdY2hlc3Qgd29ya291dCB1c2luZyBkdW1iYmVsbHM%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Arms',
    difficulty: 'Easy',
    equipment: 'Dumbbell',
    id: '5',
    instructions:
        'Perform 3 sets of 12-15 reps of bicep curls, tricep extensions, hammer curls, and diamond push-ups with 45-second rest intervals, focusing on controlled movements and peak contractions.',
    name: 'Beginner Arm Blast',
    videoUrl: 'https://www.youtube.com/watch?v=NUVo0XDd4oc&pp=ygUdY2hlc3Qgd29ya291dCB1c2luZyBkdW1iYmVsbHM%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Core',
    difficulty: 'Medium',
    equipment: 'Bodyweight',
    id: '6',
    instructions:
        'Complete 4 rounds of 30-second planks, 20 Russian twists, 15 mountain climbers, and 12 leg raises with minimal rest between exercises, focusing on bracing your core throughout each movement.',
    name: 'Core Crusher',
    videoUrl: 'https://www.youtube.com/watch?v=g2jocInockU&pp=ygUMY29yZSB3b3Jrb3V0',
  ),
  const WorkOutModel(
    bodyPart: 'Full Body',
    difficulty: 'Hard',
    equipment: 'Mixed',
    id: '7',
    instructions:
        'Perform a circuit of 8 reps of barbell squats, push-ups, pull-ups, kettlebell swings, and burpees for 5 rounds with 90-second rest between rounds, maintaining high intensity and proper form throughout.',
    name: 'Total Body Blitz',
    videoUrl: 'https://www.youtube.com/watch?v=l9_SoClAO5g&pp=ygUJZnVsbCBib2R5',
  ),
  const WorkOutModel(
    bodyPart: 'Glutes',
    difficulty: 'Medium',
    equipment: 'Resistance Band',
    id: '8',
    instructions:
        'Complete 4 sets of 15 reps of hip thrusts, glute bridges, banded squats, and fire hydrants with 60-second rest periods, focusing on squeezing your glutes at the top of each movement.',
    name: 'Glute Gains',
    videoUrl: 'https://www.youtube.com/watch?v=l9_SoClAO5g&pp=ygUJZnVsbCBib2R5',
  ),
  const WorkOutModel(
    bodyPart: 'Biceps',
    difficulty: 'Hard',
    equipment: 'Barbell',
    id: '9',
    instructions: 'Perform 5 sets of 8-10 reps of barbell curls, preacher curls, concentration curls, and hammer curls with 75-second rest periods, focusing on slow negatives and peak contractions.',
    name: 'Bicep Builder',
    videoUrl: 'https://www.youtube.com/shorts/7pUdUJXksmY',
  ),
  const WorkOutModel(
    bodyPart: 'Triceps',
    difficulty: 'Medium',
    equipment: 'Cable',
    id: '10',
    instructions:
        'Complete 4 sets of 12 reps of tricep pushdowns, overhead extensions, skull crushers, and close-grip bench press with 60-second rest intervals, focusing on full extension and controlled movements.',
    name: 'Tricep Sculptor',
    videoUrl: 'https://www.youtube.com/shorts/7pUdUJXksmY',
  ),
  const WorkOutModel(
    bodyPart: 'Cardio',
    difficulty: 'Easy',
    equipment: 'Bodyweight',
    id: '11',
    instructions:
        'Perform a 20-minute circuit of 30 seconds each of jumping jacks, high knees, butt kicks, and mountain climbers with 15-second rest between exercises, focusing on maintaining consistent effort throughout.',
    name: 'Beginner HIIT Cardio',
    videoUrl: 'https://www.youtube.com/shorts/7pUdUJXksmY',
  ),
  const WorkOutModel(
    bodyPart: 'Lower Back',
    difficulty: 'Easy',
    equipment: 'Bodyweight',
    id: '12',
    instructions: 'Complete 3 sets of 12 reps of supermans, bird-dogs, good mornings, and bridges with 45-second rest periods, focusing on controlled movements and proper spinal alignment.',
    name: 'Back Health Basics',
    videoUrl: 'https://www.youtube.com/watch?v=7V-EbW-DmN0&pp=ygUKbG93ZXIgYmFjaw%3D%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Calves',
    difficulty: 'Medium',
    equipment: 'Dumbbell',
    id: '13',
    instructions:
        'Perform 5 sets of 15-20 reps of standing calf raises, seated calf raises, single-leg calf raises, and jump rope for 60 seconds with 45-second rest intervals, focusing on full range of motion.',
    name: 'Calf Builder',
    videoUrl: 'https://www.youtube.com/watch?v=7V-EbW-DmN0&pp=ygUKbG93ZXIgYmFjaw%3D%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Upper Body',
    difficulty: 'Hard',
    equipment: 'Mixed',
    id: '14',
    instructions: 'Complete 5 sets of 6-8 reps of bench press, pull-ups, overhead press, and dips with 90-second rest periods, focusing on maximal effort and controlled eccentric phases.',
    name: 'Upper Body Strength',
    videoUrl: 'https://www.youtube.com/watch?v=7V-EbW-DmN0&pp=ygUKbG93ZXIgYmFjaw%3D%3D',
  ),
  const WorkOutModel(
    bodyPart: 'Abs',
    difficulty: 'Hard',
    equipment: 'Weighted',
    id: '15',
    instructions:
        'Perform 4 sets of 12-15 reps of weighted crunches, hanging leg raises, weighted Russian twists, and ab rollouts with 60-second rest intervals, focusing on controlled movements and full range of motion.',
    name: 'Advanced Ab Ripper',
    videoUrl: 'Best Home Ab Workout | 10 Minutes (GUARANTEED!)',
  ),
];

// final List<WorkOutModel> workOutList = [
//   const WorkOutModel(
//     bodyPart: 'Chest',
//     difficulty: 'Easy',
//     equipment: 'Dumbbell',
//     id: '1',
//     instructions:
//         'Perform 4 sets of 8-12 reps each of flat bench press, incline dumbbell press, chest flyes, and push-ups with 60-second rest between sets, focusing on full range of motion and chest contraction.',
//     name: 'Chest Easy Workout',
//     videoUrl: 'https://youtube.com/shorts/iA7QiVrG8wk',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Back',
//     difficulty: 'Medium',
//     equipment: 'Barbell',
//     id: '2',
//     instructions:
//         'Complete 4 sets of 10 reps of deadlifts, bent-over rows, lat pulldowns, and seated cable rows with 90-second rest between sets, maintaining proper form and engaging your lats throughout each movement.',
//     name: 'Back Builder Workout',
//     videoUrl: 'https://youtube.com/shorts/SuajkDYlIRw',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Legs',
//     difficulty: 'Hard',
//     equipment: 'Barbell',
//     id: '3',
//     instructions:
//         'Perform 5 sets of 6-8 reps of squats, Romanian deadlifts, lunges, and leg press with 2-minute rest periods, focusing on progressive overload and maintaining tension in your quads, hamstrings and glutes.',
//     name: 'Intense Leg Day',
//     videoUrl: 'https://youtube.com/shorts/2-UepgssxHE',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Shoulders',
//     difficulty: 'Medium',
//     equipment: 'Dumbbell',
//     id: '4',
//     instructions:
//         'Complete 4 sets of 10-12 reps of overhead press, lateral raises, front raises, and rear delt flyes with 60-second rest between exercises, focusing on controlled movements and full shoulder engagement.',
//     name: 'Shoulder Sculptor',
//     videoUrl: 'https://youtube.com/shorts/rDYO-YJ6xDg',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Arms',
//     difficulty: 'Easy',
//     equipment: 'Dumbbell',
//     id: '5',
//     instructions:
//         'Perform 3 sets of 12-15 reps of bicep curls, tricep extensions, hammer curls, and diamond push-ups with 45-second rest intervals, focusing on controlled movements and peak contractions.',
//     name: 'Beginner Arm Blast',
//     videoUrl: 'https://youtube.com/shorts/_URRHWhRE_o',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Core',
//     difficulty: 'Medium',
//     equipment: 'Bodyweight',
//     id: '6',
//     instructions:
//         'Complete 4 rounds of 30-second planks, 20 Russian twists, 15 mountain climbers, and 12 leg raises with minimal rest between exercises, focusing on bracing your core throughout each movement.',
//     name: 'Core Crusher',
//     videoUrl: 'https://youtube.com/shorts/0SoiHlIj1lU',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Full Body',
//     difficulty: 'Hard',
//     equipment: 'Mixed',
//     id: '7',
//     instructions:
//         'Perform a circuit of 8 reps of barbell squats, push-ups, pull-ups, kettlebell swings, and burpees for 5 rounds with 90-second rest between rounds, maintaining high intensity and proper form throughout.',
//     name: 'Total Body Blitz',
//     videoUrl: 'https://youtube.com/shorts/lk0Qz_Jh3mU',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Glutes',
//     difficulty: 'Medium',
//     equipment: 'Resistance Band',
//     id: '8',
//     instructions:
//         'Complete 4 sets of 15 reps of hip thrusts, glute bridges, banded squats, and fire hydrants with 60-second rest periods, focusing on squeezing your glutes at the top of each movement.',
//     name: 'Glute Gains',
//     videoUrl: 'https://youtube.com/shorts/6KqbLdQs4GE',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Biceps',
//     difficulty: 'Hard',
//     equipment: 'Barbell',
//     id: '9',
//     instructions: 'Perform 5 sets of 8-10 reps of barbell curls, preacher curls, concentration curls, and hammer curls with 75-second rest periods, focusing on slow negatives and peak contractions.',
//     name: 'Bicep Builder',
//     videoUrl: 'https://youtube.com/shorts/k1G40sUOnO0',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Triceps',
//     difficulty: 'Medium',
//     equipment: 'Cable',
//     id: '10',
//     instructions:
//         'Complete 4 sets of 12 reps of tricep pushdowns, overhead extensions, skull crushers, and close-grip bench press with 60-second rest intervals, focusing on full extension and controlled movements.',
//     name: 'Tricep Sculptor',
//     videoUrl: 'https://youtube.com/shorts/SvQJ3F0YnRo',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Cardio',
//     difficulty: 'Easy',
//     equipment: 'Bodyweight',
//     id: '11',
//     instructions:
//         'Perform a 20-minute circuit of 30 seconds each of jumping jacks, high knees, butt kicks, and mountain climbers with 15-second rest between exercises, focusing on maintaining consistent effort throughout.',
//     name: 'Beginner HIIT Cardio',
//     videoUrl: 'https://youtube.com/shorts/Yz7Ofr9z1co',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Lower Back',
//     difficulty: 'Easy',
//     equipment: 'Bodyweight',
//     id: '12',
//     instructions: 'Complete 3 sets of 12 reps of supermans, bird-dogs, good mornings, and bridges with 45-second rest periods, focusing on controlled movements and proper spinal alignment.',
//     name: 'Back Health Basics',
//     videoUrl: 'https://youtube.com/shorts/sAZJrJeskCs',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Calves',
//     difficulty: 'Medium',
//     equipment: 'Dumbbell',
//     id: '13',
//     instructions:
//         'Perform 5 sets of 15-20 reps of standing calf raises, seated calf raises, single-leg calf raises, and jump rope for 60 seconds with 45-second rest intervals, focusing on full range of motion.',
//     name: 'Calf Builder',
//     videoUrl: 'https://youtube.com/shorts/4ZmkYQlbbfY',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Upper Body',
//     difficulty: 'Hard',
//     equipment: 'Mixed',
//     id: '14',
//     instructions: 'Complete 5 sets of 6-8 reps of bench press, pull-ups, overhead press, and dips with 90-second rest periods, focusing on maximal effort and controlled eccentric phases.',
//     name: 'Upper Body Strength',
//     videoUrl: 'https://youtube.com/shorts/3MLaB4U-5Z0',
//   ),
//   const WorkOutModel(
//     bodyPart: 'Abs',
//     difficulty: 'Hard',
//     equipment: 'Weighted',
//     id: '15',
//     instructions:
//         'Perform 4 sets of 12-15 reps of weighted crunches, hanging leg raises, weighted Russian twists, and ab rollouts with 60-second rest intervals, focusing on controlled movements and full range of motion.',
//     name: 'Advanced Ab Ripper',
//     videoUrl: 'https://youtube.com/shorts/kRX3RB_Y2g4',
//   ),
// ];
