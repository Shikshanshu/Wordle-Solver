import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wordle/main.dart';
List<String> words = [];
List<List<int>> index =[];
List<String> symbols=[];
String result='';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Screen(),
  ));
}
class Screen extends StatefulWidget {
  Screen({Key? key}) : super(key: key);
  @override
  State<Screen> createState() => _ScreenState();
}
class _ScreenState extends State<Screen> {
  TextEditingController textarea = TextEditingController();
  Widget guess(String word,int i){
    List<Color> colors=[Colors.grey.shade800,Colors.lime.shade600,Colors.green.shade600];
    List<String> sym=['_','?','+'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            setState((){
              index[i][0]++;
              index[i][0]%=3;
              symbols[i]=symbols[i].substring(0,6)+sym[index[i][0]]+symbols[i].substring(7);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[index[i][0]],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: colors[index[i][0]].withOpacity(0.8),
                  offset: const Offset(0,3),
                  blurRadius: 1,
                  spreadRadius: 0
                )
              ],
            ),
            child:Align(
              alignment: Alignment.center,
              child : Text(word[0],textAlign: TextAlign.center,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState((){
              index[i][1]++;
              index[i][1]%=3;
              symbols[i]=symbols[i].substring(0,7)+sym[index[i][1]]+symbols[i].substring(8);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[index[i][1]],
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),
            child:Align(
              alignment: Alignment.center,
              child: Text(word[1],textAlign: TextAlign.center,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState((){
              index[i][2]++;
              index[i][2]%=3;
              symbols[i]=symbols[i].substring(0,8)+sym[index[i][2]]+symbols[i].substring(9);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[index[i][2]],
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),
            child:Align(
              alignment: Alignment.center,
              child: Text(word[2],textAlign: TextAlign.center,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState((){
              index[i][3]++;
              index[i][3]%=3;
              symbols[i]=symbols[i].substring(0,9)+sym[index[i][3]]+symbols[i].substring(10);
            });
          },
          child: Container(
            height: 40,
            width: 40,
            decoration : BoxDecoration(
              color: colors[index[i][3]],
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),
            child:Align(
              alignment: Alignment.center,
              child: Text(word[3],textAlign: TextAlign.center,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState((){
              index[i][4]++;
              index[i][4]%=3;
              symbols[i]=symbols[i].substring(0,10)+sym[index[i][4]]+symbols[i].substring(11);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors[index[i][4]],
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),
            child:Align(
              alignment: Alignment.center,
                child: Text(word[4],textAlign: TextAlign.center,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              symbols.removeAt(words.indexOf(word));
              index.removeAt(words.indexOf(word));
              words.remove(word);

              //print(words);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color : Colors.red,
              shape : BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.8),
                  offset: const Offset(0,3),
                  blurRadius: 1,
                  spreadRadius: 0,
                )
              ],
            ),
            child:Align(
            alignment : Alignment.center,
              child : Text('X',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
          ),
          ),
        ),
      ],
    );
  }
  Future<void> calling() async{
      http.Response res = await http.post(
      Uri.parse('http://10.1.3.19:3000/first'),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'guess' : symbols,
      }),

    );
      result = ((jsonDecode(res.body)['result'][0]));
  }
  Widget form(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: TextField(
            controller: textarea,
            onSubmitted: (String word){
              if(word.length!=5){
                Fluttertoast.showToast(
                    msg: "Invalid input",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.orange
                );
              }
              else
                {
                  setState(() {
                    words.add(word.toUpperCase());
                    index.add([0, 0, 0, 0, 0]);
                    symbols.add('$word:_____');
                    //print(symbols);
                  });
                }
                textarea.clear();
            },
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2.0,fontSize: 16),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white,width: 0),
              ),
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(color: Colors.white),
              isDense : true,
              contentPadding: const EdgeInsets.all(10),
              hintText: 'ENTER A WORD',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold,letterSpacing: 2.0),
            ),
          ),
        ),
      ],
    );
  }
  Widget getSuggestion(){
    return GestureDetector(
      onTap: () async{
        await calling();
        setState((){
          //calling()
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          border: Border.all(color: Colors.green.shade600,),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade600.withOpacity(0.8),
              offset: const Offset(0,3),
              blurRadius: 1,
              spreadRadius: 0
            )
          ],
        ),
        width: 200,
        height: 40,
        child :const Align(
          alignment: Alignment.center,
            child: Text('GET SUGGESTIONS',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2.0))
        )
      ),
    );
  }
  Widget gap(){
    return Container(
      height: 20,
      width: 20,
      color: const Color.fromARGB(255, 18, 18, 19).withOpacity(0),
    );
  }
  @override
  void initState() {
    words=[];
    index=[];
    symbols=[];
    result='';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //print(words);
    //print("k");
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORDLE SOLVER',
          style: TextStyle(
            letterSpacing: 2.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column (
        children: [
          gap(),
          Column(
            children: words.map((word) {
              return guess(word,words.indexOf(word));
          }).toList(),
          ),
          const Expanded(child: SizedBox()),
          (result!='')?Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      border: Border.all(color: Colors.green.shade600),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade600.withOpacity(0.8),
                          offset: Offset(0,3),
                          blurRadius: 1,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
              child : Align(
                alignment :Alignment.center,
                child : Text('SUGGESTIONS : ' + result.toUpperCase(),textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16,letterSpacing: 2.0),),
            ),
            ),
           ):Container(),

          form(),
          getSuggestion(),
          gap(),
        ],
      ),
      //),
      backgroundColor: const Color.fromARGB(255,18,18,19),

    );
  }
}