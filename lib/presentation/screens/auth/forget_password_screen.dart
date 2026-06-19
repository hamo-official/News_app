import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xffF5F8FF),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 25,

          title: Row(
            children: [

              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffEAF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: Color(0xff063B8C),
                ),
              ),

              SizedBox(width: 10),

              Text(
                "NovaNews",
                style: TextStyle(
                  color: Color(0xff063B8C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.help_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),


      body: Center(
        child: Container(

          width: 330,

          padding: EdgeInsets.all(25),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(25),

            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black12,
              )
            ],
          ),


          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Container(
                padding: EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Color(0xffEEF5FF),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(
                  Icons.grid_view,
                  color: Color(0xff063B8C),
                ),
              ),


              SizedBox(height: 25),


              Text(
                "Reset Password",

                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),


              SizedBox(height: 10),


              Text(
                "Lost your way? Enter your email and\nwe'll help you get back to your news.",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),


              SizedBox(height: 30),


              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),


              SizedBox(height: 8),


              TextField(

                decoration: InputDecoration(

                  hintText: "name@example.com",

                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),

                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(12),

                    borderSide: BorderSide.none,
                  ),

                  filled: true,

                  fillColor: Color(0xffF8FAFF),
                ),
              ),


              SizedBox(height: 20),


              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Color(0xff063B8C),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(12),

                    ),
                  ),

                  onPressed: (){},

                  child: Text(
                    "Send Reset Link  →",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),


              SizedBox(height: 25),


              TextButton(

                onPressed: (){

                  Navigator.pop(context);

                },

                child: Text(
                  "←  Back to Login",
                  style: TextStyle(
                    color: Color(0xff063B8C),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}