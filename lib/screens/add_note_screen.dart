import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/local/database_helper.dart';
import 'package:provider/provider.dart';

import '../helpers/color_helper.dart';
import '../helpers/data_base.dart';
import '../provider/db_provider.dart';

class AddNoteScreen extends StatefulWidget {
   AddNoteScreen({super.key, this.isUpdating = false, this.id});

   final bool isUpdating;
   final int? id;


  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final FocusNode titleFocus = FocusNode();

  final FocusNode notesFocus = FocusNode();

  final random = Random();

  @override
  void initState() {
    super.initState();

    if(widget.isUpdating) {
      context.read<DbProvider>().fetchSingleNote(id: widget.id!);
    }
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
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: ()  {

                      if(widget.isUpdating) {
                        context.read<DbProvider>().updateNote(id: widget.id!, title: titleController.text, desc: notesController.text);
                        Navigator.pop(context);
                      }else {
                        if(titleController.text.isNotEmpty || notesController.text.isNotEmpty) {

                          context.read<DbProvider>().addNote(title: titleController.text, desc: notesController.text);
                          Navigator.pop(context);
                        }else {

                          if(titleController.text.isEmpty) {
                            titleFocus.requestFocus();
                          }else {
                            notesFocus.requestFocus();
                          }

                        }
                      }


                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: ColorHelper.lightBlack,
                          borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),

              Expanded(
                child: Consumer<DbProvider>(
                  builder: (context, provider, child) {
                    Map<String, dynamic> data = provider.getSingleNoteData();
                    titleController.text = data[DatabaseHelper.Title_Col] ?? "";
                    notesController.text = data[DatabaseHelper.Description_Col] ?? "";
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            TextField(
                              controller: titleController,
                              focusNode: titleFocus,
                              magnifierConfiguration:
                              TextMagnifierConfiguration.disabled,
                              selectionControls: EmptyTextSelectionControls(),
                              maxLines: null,
                              maxLength: 60,
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: Colors.white,
                              cursorHeight: 36,
                              decoration: const InputDecoration(
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                counterText: "",
                                // filled: true,
                                // fillColor: Colors.red

                              ),
                            ),

                            const SizedBox(height: 10),

                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: TextField(
                                controller: notesController,
                                focusNode: notesFocus,
                                magnifierConfiguration:
                                TextMagnifierConfiguration.disabled,
                                selectionControls: EmptyTextSelectionControls(),
                                maxLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                cursorHeight: 20,
                                decoration: const InputDecoration(
                                  hintText: "Type something...",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                  border: InputBorder.none,

                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                ),
              ),






            ],
          ),
        ),
      ),
    );
  }
}
