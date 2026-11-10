import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/local/database_helper.dart';
import 'package:note_app/helpers/color_helper.dart';
import 'package:note_app/provider/db_provider.dart';
import 'package:note_app/routers/app_router.dart';
import 'package:provider/provider.dart';

import '../helpers/note_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<DbProvider>().getInitData();
  }


  @override
  Widget build(BuildContext context) {

    print("main build");
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: Colors.white.withValues(alpha: 0.4)
            )
          ),
          child: FilledButton(
            onPressed: () async {
              Navigator.pushNamed(context, AppRouter.add_note_screen);
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 5,
            ),
            child: Icon(Icons.add, color: Colors.white, size: 36),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [

              // header-------->
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorHelper.lightBlack,
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    child: Icon(Icons.search, color: Colors.white, size: 28),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // note lists ------->
              Consumer<DbProvider>(builder: (context, provider, child) {
                print("consumer build --- home");
                List<Map<String,dynamic>> notes = provider.getNotesData();
                return notes.isEmpty ? Expanded(
                  child: Center(
                    child: Text(
                      "No Data!",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 20
                      ),
                    ),
                  ),
                ) : Expanded(
                  child: MasonryGridView.builder(
                    padding: EdgeInsets.only(top: 10),
                    gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300
                    ),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    itemBuilder: (context, index) {

                      return InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, AppRouter.notes_screen, arguments: notes[index][DatabaseHelper.Note_Id_Col]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: backgroundColors[notes[index][DatabaseHelper.Bg_Color_Col]],
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                notes[index][DatabaseHelper.Title_Col],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              SizedBox(height: 50),
                              Text(
                                DateFormat("MMM dd yyyy").format(
                                  DateTime.parse(
                                    notes[index][DatabaseHelper.Date_Col],
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: notes.length,
                  ),
                );
              })

            ],
          ),
        ),
      ),
    );
  }
}
