import 'package:docs_clon_flutter/Screen/document_screen.dart';
import 'package:docs_clon_flutter/Screen/home_screen.dart';
import 'package:docs_clon_flutter/Screen/login_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

final  loggedoutRout=RouteMap(routes: {'/' : (route) =>  MaterialPage(child:LoginScreen(),),});


final  loggedInRout=RouteMap(routes: {
  '/' : (route) => MaterialPage(child:HomeScree(),),
 // '/document/:id' : (route) => MaterialPage(child:DocumentScreen(id: route.pathParameters['id'] ?? '',),),
'/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),

  },);


