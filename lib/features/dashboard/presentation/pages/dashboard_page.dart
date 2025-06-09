import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_view_coach.dart';
import 'package:coachup/core/utils/empty_list_data.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/core/utils/ui_mode_helper.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isHeader = false;
  int today = 1;
  DashboardEntity dash = DashboardEntity();
  List<CoachEntity> allCoaches = [];
  @override
  void initState() {
    super.initState();
    UiModeHelper.enableDefault();
    context.read<DashboardBloc>().add(GetDashboardEvent(today));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is GetDashboardLoading) {
          LoadingDialog.show();
        } else if (state is GetDashboardFailure) {
          LoadingDialog.hide();
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is GetDashboardLoaded) {
            dash = state.data;
            allCoaches = state.data.coaches;
            LoadingDialog.hide();
          }
          return bodyForm();
        },
      ),
    );
  }

  Widget bodyForm() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage(
                  MediaRes.omboarding,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.6,
                  child: Text(
                    dash.name == '' ? 'Your Name' : dash.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: blackTextstyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Text(
                    dash.title == '' ? 'Your Title' : dash.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: transTextstyle.copyWith(
                      fontSize: 13,
                      fontWeight: medium,
                      color: AppColors.bgGreySecond,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SvgPicture.asset(
            MediaRes.notification,
            fit: BoxFit.contain,
            width: 20,
            // ignore: deprecated_member_use
            color: AppColors.bgBlack,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),
            Container(
              // height: size.height * 0.2,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Today',
                          style: transTextstyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                            color: AppColors.bgBlack,
                          ),
                        ),
                        CustomInkWell(
                          onTap: () {
                            setState(() {
                              isHeader = !isHeader;
                            });
                          },
                          child: Icon(
                            isHeader
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(
                        style: blackTextstyle.copyWith(
                          fontSize: 13,
                          fontWeight: light,
                        ), // gaya teks default
                        children: [
                          const TextSpan(
                              text: 'Saat ini, kamu tercatat memiliki '),
                          TextSpan(
                            text: '${dash.coach} pengajaran',
                            style: blackTextstyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' di '),
                          TextSpan(
                            text: '${dash.collage} sekolah',
                            style: blackTextstyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ', dengan total sekitar '),
                          TextSpan(
                            text: '${dash.student} murid',
                            style: blackTextstyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    children: [
                      Text(
                        'Today',
                        style: transTextstyle.copyWith(
                          fontSize: 12,
                          fontWeight: bold,
                          color: AppColors.bgBlack,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            allCoaches.isNotEmpty
                ? Column(
                    children: allCoaches.map((e) {
                      return CustomInkWell(
                        onTap: () {
                          //
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: ListCoaching(dt: e, size: size),
                        ),
                      );
                    }).toList(),
                  )
                : EmptyListData(
                    size: size,
                    message: 'Tidak ada data Pelatihan hari ini',
                  ),
          ],
        ),
      ),
    );
  }
}
