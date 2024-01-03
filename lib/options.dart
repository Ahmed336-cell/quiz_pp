import 'package:flutter/material.dart';
class Options extends StatelessWidget {
  String option;
   Options({required this.option});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 3,color: Color(0xffA42FC1))
          ),

          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(option,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),),
                  Radio(value: option, groupValue: 2, onChanged: (val){

                  })
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
