import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/local/database_helper.dart';
import 'package:note_app/helpers/data_base.dart';
import 'package:note_app/provider/db_provider.dart';
import 'package:note_app/routers/app_router.dart';
import 'package:provider/provider.dart';
import '../helpers/color_helper.dart';


class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, required this.id});

  final int id;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    context.read<DbProvider>().fetchSingleNote(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorHelper.lightBlack,
                          borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                      child: Center(child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24,)),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, AppRouter.add_note_screen, arguments: {
                        "isUpdating": true,
                        "id": data[DatabaseHelper.Note_Id_Col]
                      });
                    },
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorHelper.lightBlack,
                          borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 24,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),

              Consumer<DbProvider>(
                builder: (context, provider, child) {
                  data = provider.getSingleNoteData();
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 10),
                      children: [
                        Text(
                          data[DatabaseHelper.Title_Col] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600
                          ),
                        ),

                        SizedBox(height: 20,),

                        Text(
                          data[DatabaseHelper.Date_Col] != null
                              ? DateFormat("MMM dd yyyy").format(
                            DateTime.parse(
                              data[DatabaseHelper.Date_Col].toString(),
                            ),
                          )
                              : "",
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 16,

                          ),
                        ),

                        SizedBox(height: 20,),

                        Text(
                          data[DatabaseHelper.Description_Col] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.7

                          ),
                        ),
                      ],
                    ),
                  );
                }
              )


            ],
          ),
        ),
      ),
    );
  }
}
