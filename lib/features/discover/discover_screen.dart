import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakponts.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController = TextEditingController(
    text: "Initial Text",
  );

  // bool _isWriting = false;

  void _onSearchChanged(String value) {
    // print("Searching from $value");
  }

  void _onSearchSubmitted(String value) {
    // print("Submitted $value");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // void _onStartWriting() {
  //   setState(() {
  //     _isWriting = true;
  //   });
  // }

  // void _stopWriting() {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     _textEditingController.clear();
  //     _isWriting = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: CupertinoSearchTextField(
            controller: _textEditingController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            style: TextStyle(
              color: isDarkMode(context) ? Colors.white : Colors.black,
            ),
          ),
          // title: Container(
          //   constraints: const BoxConstraints(
          //     maxWidth: Breakpoints.sm,
          //   ),
          //   child: SizedBox(
          //     height: Sizes.size36,
          //     child: TextField(
          //       controller: _textEditingController,
          //       onTap: _onStartWriting,
          //       expands: true,
          //       minLines: null,
          //       maxLines: null,
          //       textInputAction: TextInputAction.newline,
          //       cursorColor: Theme.of(context).primaryColor,
          //       decoration: InputDecoration(
          //         hintText: 'Search',
          //         hintStyle: const TextStyle(
          //           fontSize: Sizes.size16,
          //           color: Colors.grey,
          //         ),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(Sizes.size6),
          //           borderSide: BorderSide.none,
          //         ),
          //         filled: true,
          //         fillColor: Colors.grey.shade100,
          //         contentPadding: const EdgeInsets.symmetric(
          //           horizontal: Sizes.size10,
          //         ),
          //         prefixIconConstraints: const BoxConstraints(
          //           minWidth: 30,
          //         ),
          //         prefixIcon: Padding(
          //           padding: const EdgeInsets.only(
          //             left: Sizes.size8,
          //           ),
          //           child: FaIcon(
          //             FontAwesomeIcons.magnifyingGlass,
          //             color: Colors.grey.shade500,
          //             size: Sizes.size18,
          //           ),
          //         ),
          //         suffixIconConstraints: const BoxConstraints(
          //           minWidth: 30,
          //         ),
          //         suffixIcon: Padding(
          //           padding: const EdgeInsets.only(
          //             right: Sizes.size8,
          //           ),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               if (_isWriting)
          //                 GestureDetector(
          //                   onTap: _stopWriting,
          //                   child: FaIcon(
          //                     FontAwesomeIcons.solidCircleXmark,
          //                     color: Colors.grey.shade500,
          //                     size: Sizes.size18,
          //                   ),
          //                 ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          centerTitle: true,
          bottom: TabBar(
            onTap: (value) => FocusScope.of(context).unfocus(),
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(Sizes.size6),
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constrains) => Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.size4,
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2080&q=80",
                        ),
                      ),
                    ),
                    Gaps.v10,
                    const Text(
                      "This is a very long caption for my tiktok that im upload just now currently.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Gaps.v8,
                    if (constrains.maxWidth < 200 || constrains.maxWidth > 250)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                "https://avatars.githubusercontent.com/u/3871193",
                              ),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                "My avatar is going to be very long",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text("2.5M"),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
