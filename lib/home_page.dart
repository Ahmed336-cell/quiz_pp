import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz_pp/options.dart';
import 'package:http/http.dart' as http;
import 'completed_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List responseData=[];
  int number=0;
  List shuffeldOptions=[];
  late Timer _timer;
  int _second=15;
  Future api() async{
    final response = await http.get(Uri.parse("https://opentdb.com/api.php?amount=10"));
    if(response.statusCode==200){
      var data = jsonDecode(response.body)['results'];
      setState(() {
        responseData=data;
      });
    }
  }
  Future<void> initializeData() async {
    await api();
    updateShuffledOption();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api();
    initializeData();
    startTime();

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 421,
              width: 400,
              child: Stack(
                children: [
                  Container(
                    height: 240,
                    width: 390,
                    decoration: BoxDecoration(
                      color: const Color(0xffA42FC1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                      left: 22,
                      child: Container(
                        height: 170,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,1),
                              blurRadius: 5,
                              spreadRadius: 3,
                              color: Color(0xffA42FC1).withOpacity(0.4)
                            )
                          ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("05",style:TextStyle(
                                    color: Colors.green,
                                    fontSize: 20
                                  )),
                                  Text("07",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20
                                    ),
                                  )
                                ],
                              ),
                              Center(
                                child: Text("Question ${number+1}/10",
                                style: TextStyle(
                                  color: Color(0xffA42FC1),
                                ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(responseData.isNotEmpty?responseData[number]['question']:"")
                            ],
                          ),
                        ),
                      )
                  ),

                  Positioned(
                    bottom: 210,
                      left: 140,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Text("$_second",
                            style: TextStyle(
                              color: Color(0xffA42FC1),
                              fontSize: 25
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
           Column(
             children:(responseData.isNotEmpty&&responseData[number]["incorrect_answers"]!=null)?
                 shuffeldOptions.map((option) {
               return Options(option: option.toString());
             }).toList():[],
           ),
            const SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffA42FC1),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5
                ),
                onPressed: (){
                 nextQuestion();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text("Next",
                  style: TextStyle(
                    color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,
                  ),),
                ),
              ),

            )
          ],
        ),
      ),

    );
  }

  void nextQuestion(){
    if(number==9) {
      complted();
    }
    setState(() {
      number++;
      updateShuffledOption();
      _second=15;
    });
  }

  void complted() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=>Completed())
    );
  }
  void updateShuffledOption(){
    setState(() {
      shuffeldOptions=shuffeldOption(
        [
          responseData[number]["correct_answer"],
          ...(responseData[number]["incorrect_answers"]as List)
        ]
      );
    });
  }
  List <String> shuffeldOption(List<String>option){
    List <String>options=List.from(option);
    options.shuffle();
    print(options);
    return options;
  }

  void startTime(){
    _timer=Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {
        if(_second>0){
          _second--;
        }else{
          nextQuestion();
          updateShuffledOption();
        }
      });
    });
  }
}
