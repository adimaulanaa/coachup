import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_search_field.dart';
import 'package:coachup/core/utils/empty_list_data.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_bloc.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_event.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_state.dart';
import 'package:coachup/features/privates/presentation/pages/created_privates_page.dart';
import 'package:coachup/features/privates/presentation/pages/detail_private_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PrivatesPage extends StatefulWidget {
  const PrivatesPage({super.key});

  @override
  State<PrivatesPage> createState() => _PrivatesPageState();
}

class _PrivatesPageState extends State<PrivatesPage> {
  late PrivatesBloc _privatesBloc;
  TextEditingController searchController = TextEditingController();
  bool initialized = false;
  String today = '';
  List<PrivatesEntity> privates = [];
  List<PrivatesEntity> allPrivates = [];
  @override
  void initState() {
    super.initState();
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _privatesBloc = context.read<PrivatesBloc>();
    _privatesBloc.add(ListPrivatesEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringResources.privates,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<PrivatesBloc, PrivatesState>(
        listener: (context, state) {
          if (state is ListPrivatesLoading) {
            LoadingDialog.show();
          } else if (state is ListPrivatesFailure) {
            LoadingDialog.hide();
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          }
        },
        child: BlocBuilder<PrivatesBloc, PrivatesState>(
          builder: (context, state) {
            if (state is ListPrivatesLoaded) {
              allPrivates = state.data;
              if (!initialized) {
                privates = allPrivates;
                initialized = true;
              }
              LoadingDialog.hide();
            }
            return bodyForm();
          },
        ),
      ),
    );
  }

  Widget bodyForm() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    controller: searchController,
                    hintText: 'Cari Nama Private...',
                    onChanged: (value) {
                      search(value);
                    },
                    onClear: () {
                      searchController.clear();
                      search('');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                CustomInkWell(
                  onTap: () {
                    navCreated();
                  },
                  child: SvgPicture.asset(
                    MediaRes.created,
                    // ignore: deprecated_member_use
                    color: AppColors.bgGreySecond,
                    width: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            privates.isNotEmpty
                ? Column(
                    children: privates.map((e) {
                      return listPrivate(size, e);
                    }).toList(),
                  )
                : EmptyListData(
                    size: size,
                    message: 'Tidak ada data Privates',
                  ),
          ],
        ),
      ),
    );
  }

  Widget listPrivate(Size size, PrivatesEntity e) {
    return CustomInkWell(
      onTap: () async {
        // Melakukan navigasi ke halaman detail
        await AppNavigator.push(
          DetailPrivatePage(private: e),
          transition: TransitionType.fade,
        );
        if (mounted) {
          initialized = false; // reset biar filter di-refresh
          // Lakukan refresh atau panggil event untuk mengambil data coaching
          context.read<PrivatesBloc>().add(ListPrivatesEvent(''));
        }
      },
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.name.toString(),
              style: blackTextstyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Deskripsi : ${e.description}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: blackTextstyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navCreated() async {
    await AppNavigator.push(
      const CreatedPrivatesPage(),
      transition: TransitionType.fade,
    );
    if (mounted) {
      initialized = false; // reset biar filter di-refresh
      context.read<PrivatesBloc>().add(ListPrivatesEvent(''));
    }
  }

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Pencarian berdasarkan nama
    privates = [];
    if (lowerCaseQuery.isEmpty) {
      privates = allPrivates;
    } else {
      privates = allPrivates
          .where((e) => e.name!.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
    setState(() {});
  }
}
