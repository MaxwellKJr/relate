import 'package:flutter/material.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/components/post/post_tile.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostViewModel>(context, listen: false).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text("Relate"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: layoutPadding,
                  right: layoutPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Issues",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<PostViewModel>(
                      builder: (context, postViewModel, child) {
                        if (postViewModel.posts.isNotEmpty) {
                          return ListView.builder(
                            itemCount: postViewModel.posts.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PostTile(
                                post: postViewModel.posts[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: const DrawerMain(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostIssueScreen(),
              ),
            );
          },
          backgroundColor: primaryColor,
          elevation: 3,
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
        bottomNavigationBar: const NavigationBarMain(),
      ),
    );
  }
}

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<PostViewModel>(context, listen: false).getPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar.medium(
//               // leading: const Icon(Icons.menu),
//               title: const Text("Relate"),
//               actions: [
//                 IconButton(
//                     onPressed: () {}, icon: const Icon(Icons.logout_outlined)),
//               ],
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     left: layoutPadding, right: layoutPadding),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Recent Issues",
//                         style: TextStyle(
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.w600,
//                             color: primaryColor),
//                       ),
//                       Consumer<PostViewModel>(
//                         builder: (context, postViewModel, child) {
//                           return Expanded(
//                             child: ListView.builder(
//                               itemCount: postViewModel.posts.length,
//                               itemBuilder: (context, index) {
//                                 return PostTile(
//                                     post: postViewModel.posts[index]);
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ]),
//               ),
//             ),
//           ],
//         ),
//         drawer: const DrawerMain(),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) {
//                 return const PostIssueScreen();
//               },
//             ));
//           },
//           backgroundColor: primaryColor,
//           elevation: 3,
//           child: const Icon(
//             Icons.add,
//             color: whiteColor,
//           ),
//         ),
//         bottomNavigationBar: const NavigationBarMain(),
//       ),
//     );
//   }
// }
