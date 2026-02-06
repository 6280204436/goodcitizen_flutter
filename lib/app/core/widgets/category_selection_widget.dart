import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/core/utils/common_item_model.dart';

class CategorySelectionWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onIndexChanged;
  final List<CommonItemModel> categoriesList;

  const CategorySelectionWidget(
      {super.key,
      this.selectedIndex = 0,
      required this.onIndexChanged,
      required this.categoriesList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greyColorLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(radius_40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            categoriesList.length, (index) => _singleItemWidget(index)),
      ).paddingSymmetric(horizontal: margin_8),
    );
  }

  Widget _singleItemWidget(index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onIndexChanged(index);
        },
        child: Container(
          decoration: index == selectedIndex
              ? BoxDecoration(
                  color: whiteAppColor,
                  borderRadius: BorderRadius.circular(radius_30),
                )
              : null,
          child: Center(
            child: TextView(
                text: categoriesList[index].title ?? '',
                textStyle: textStyleTitleSmall()
                   !.copyWith(fontWeight: FontWeight.w500)),
          ).paddingSymmetric(horizontal: margin_5, vertical: margin_6),
        ).paddingSymmetric(vertical: margin_8),
      ),
    );
  }
}
