import 'package:addistutor_student/Screens/Home/components/course_info_screen.dart';
import 'package:addistutor_student/Screens/search/components/hotel_list_view.dart';
import 'package:addistutor_student/Screens/search/components/model/hotel_list_data.dart';
import 'package:addistutor_student/controller/geteducationlevelcontroller.dart';
import 'package:addistutor_student/controller/getlocationcontroller.dart';
import 'package:addistutor_student/controller/getsubjectcontroller.dart';
import 'package:addistutor_student/controller/searchcontroller.dart';
import 'package:addistutor_student/remote_services/service.dart';
import 'package:addistutor_student/remote_services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'dart:ui';
import 'package:need_resume/need_resume.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants.dart';
import 'calendar_popup_view.dart';
import 'filters_screen.dart';
import 'hotel_app_theme.dart';

class SerachPage extends StatefulWidget {
  const SerachPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SerachPage> with TickerProviderStateMixin {
  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
  }

  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  final ScrollController _scrollController = ScrollController();
  SearchController searchController = Get.find();

  GetEducationlevelController getEducationlevelController = Get.find();
  GetSubjectController getSubjectController = Get.find();
  GetLocationController getLocationController = Get.find();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<GetSubject> subject = [];

  final List<String> _tobeSent = [];
  late String sid = "";
  late var macthgender = "Any".obs;
  var lid = 1, gender = "";
  RxInt found = 0.obs;
  bool showsubject = false;
  bool searched = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    _getall();
  }

  _getall() async {
    _geteducation();
    _getsubject();
    _getlocation();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    setState(() {
      _getsubject();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    //if(mounted)
    // setState(() {

    // });
    _refreshController.loadComplete();
  }

  List<GetLocation> location = [];
  _getlocation() async {
    getLocationController.fetchLocation();
    // ignore: invalid_use_of_protected_member
    location = getLocationController.listlocation.value;
    if (location != null && location.isNotEmpty) {
      setState(() {
        getLocationController.location = location[0];
      });
    }
  }

  List<GetEducationlevel> education = [];

  _geteducation() async {
    getEducationlevelController.fetchLocation();
    // ignore: invalid_use_of_protected_member
    education = getEducationlevelController.listeducation.value;

    if (education != null && education.isNotEmpty) {
      setState(() {
        getEducationlevelController.education = education[0];
      });
    }
  }

  List<GetSubject> _selectedItems2 = [];
  _getsubject() {
    subject = getSubjectController.listsubject.value;
    if (subject != null && subject.isNotEmpty) {
      setState(() {
        //  getSubjectController.subject = subject[0];
      });
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => getEducationlevelController.isfetchededucation.value
        ? Theme(
            data: HotelAppTheme.buildLightTheme(),
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,

                //cheak pull_to_refresh
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: Scaffold(
                  body: Stack(
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Column(
                          children: <Widget>[
                            getAppBarUI(),
                            Expanded(
                                child: NestedScrollView(
                              controller: _scrollController,
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: <Widget>[
                                          gradebarfilter(),
                                          showsubject
                                              ? subjectViewUI()
                                              : Container(),
                                          LocationFilter(),
                                          genderViewUI(),
                                          getSearchBarUI(),
                                        ],
                                      );
                                    }, childCount: 1),
                                  ),
                                  SliverPersistentHeader(
                                    pinned: true,
                                    floating: true,
                                    delegate: ContestTabHeader(
                                      getFilterBarUI(),
                                    ),
                                  ),
                                ];
                              },
                              body: searched
                                  ? Container(
                                      color: HotelAppTheme.buildLightTheme()
                                          .backgroundColor,
                                      child: FutureBuilder(
                                          future: RemoteServices.search(
                                              lid.toString(),
                                              sid,
                                              gender.toString()),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasError) {
                                              found.value =
                                                  snapshot.data.length;
                                              return Center(
                                                child: Text(
                                                    snapshot.error.toString()),
                                              );
                                            }

                                            if (snapshot.hasData) {
                                              return Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return HotelListView(
                                                      callback: () {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder:
                                                                (context,
                                                                    animation1,
                                                                    animation2) {
                                                              return CourseInfoScreen(
                                                                hotelData:
                                                                    snapshot.data[
                                                                        index],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      hotelData:
                                                          snapshot.data[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          }))
                                  : const Center(
                                      child: Text("No Tutors found"),
                                    ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )))
        : const Center(child: CircularProgressIndicator()));
  }

  Widget genderViewUI() {
    var grade;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tutor Gender:',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: DropdownButton<String>(
            value: macthgender.value,
            isExpanded: true,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
            items: <String>[
              'Any',
              'Male',
              'Female',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                macthgender.value = value!;
              });

              gender = macthgender.value;

              if (macthgender.value == "Any") {
                gender = "";
              }
            },
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget LocationFilter() {
    var grade;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Location :',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: DropdownButton<GetLocation>(
            hint: Text(
              getLocationController.listlocation.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            isExpanded: true,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
            items: location
                .map((e) => DropdownMenuItem(
                      child: Text(
                        e.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                getLocationController.location = value!;
                lid = value.id;
              });

              // pop current page
            },
            value: getLocationController.location,
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget subjectViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MultiSelectBottomSheetField<GetSubject>(
          initialChildSize: 0.6,
          maxChildSize: 0.95,
          listType: MultiSelectListType.LIST,
          checkColor: Colors.pink,
          selectedColor: kPrimaryColor,
          selectedItemsTextStyle: const TextStyle(
            fontSize: 20,
            color: kPrimaryColor,
          ),
          unselectedColor: kPrimaryColor.withOpacity(.08),
          buttonIcon: const Icon(
            Icons.add,
            color: Colors.pinkAccent,
          ),
          searchHintStyle: const TextStyle(
            fontSize: 12,
          ),
          searchable: true,
          buttonText: const Text(
            "Select Subject:", //"????",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
          title: const Text(
            "Subjects avalable",
            style: TextStyle(
              fontSize: 20,
              color: kPrimaryColor,
            ),
          ),
          items: getSubjectController.hobItem,
          onConfirm: (values) {
            setState(() {
              _selectedItems2 = values.cast<GetSubject>();
            });

            for (var item in _selectedItems2) {
              // ignore: unnecessary_string_interpolations
              _tobeSent.add("${item.title.toString()}");
              // sid.add("${item.id.toString()}");
              setState(() {
                sid = item.id.toString();
              });
            }

            /*senduserdata(
                      'partnerreligion', '${_selectedItems2.toString()}');*/
          },
          chipDisplay: MultiSelectChipDisplay(
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            onTap: (value) {
              setState(() {
                _selectedItems2.remove(value);
                _tobeSent.remove(value.toString());
                //   sid.clear();
                //     sid = ("");
              });
              //  sid.clear();
              // ignore: avoid_print

              for (var item in _selectedItems2) {
                _tobeSent.add(item.title.toString());
              }
            },
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  loadData() {
    // Here you can write your code for open new view
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 1000), () {
// Here you can write your code

      EasyLoading.dismiss();
    });
  }

  Widget gradebarfilter() {
    var grade;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Education Level:',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: DropdownButton<GetEducationlevel>(
            hint: Text(
              getEducationlevelController.education.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            isExpanded: true,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
            items: education
                .map((e) => DropdownMenuItem(
                      child: Column(children: [
                        Text(
                          e.title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                getEducationlevelController.education = value!;
                //     sid = ("");
              });

              _onRefresh();
              loadData();

              getSubjectController.fetchLocation(value!.id.toString());

              // pop current page

              showsubject = true;
            },
            value: getEducationlevelController.education,
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getSearchBarUI() {
    return Positioned(
      top: 10,
      bottom: 10,
      child: Container(
        decoration: BoxDecoration(
          color: HotelAppTheme.buildLightTheme().primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(38.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 2),
                blurRadius: 8.0),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {
              setState(() {
                searched = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(FontAwesomeIcons.search,
                  size: 20,
                  color: HotelAppTheme.buildLightTheme().backgroundColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Center(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tutors Found",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              height: AppBar().preferredSize.height,
            ),
            Center(
              child: Text(
                'Search the best Tutors',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
