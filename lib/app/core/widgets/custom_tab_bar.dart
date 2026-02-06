import 'package:good_citizen/app/core/utils/common_item_model.dart';

import '../../export.dart';
import '../external_packages/tab_selector/src/tab.dart';
import '../external_packages/tab_selector/src/tab_bar.dart';

class CustomTabBar extends StatelessWidget {
  final List<CommonItemModel> items;
  final TabController? tabController;
  final Function(int index)? onChanged;

  const CustomTabBar(
      {super.key,
      required this.items,
      this.tabController,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: height_1, color: AppColors.appColor),
          borderRadius: BorderRadius.circular(radius_40)),
      child: SegmentedTabControl(
        radius: Radius.circular(radius_40),
        backgroundColor: whiteAppColor,
        onChanged: onChanged,
        controller: tabController,
        indicatorColor: Colors.orange.shade200,
        tabTextColor: AppColors.appColor,
        indicatorPadding: EdgeInsets.zero,
        tabPadding: EdgeInsets.zero,
        selectedTextStyle: textStyleTitleSmall()
            !.copyWith(color: whiteAppColor, fontWeight: FontWeight.bold),
        textStyle: textStyleTitleSmall()
            !.copyWith(color: AppColors.appColor, fontWeight: FontWeight.bold),
        tabs: List.generate(
            items.length,
            (index) =>
                SegmentTab(label: items[index].title ?? '', color: AppColors.appColor)),
      ),
    );
  }
}
