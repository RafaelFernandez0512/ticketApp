import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/utils.dart';

class CustomDropdown<T, K> extends StatelessWidget {
  final List<T> items;
  final bool enabled;

  final List<Map<String, dynamic>>? itemsMap;

  final String labelText;
  final ValueChanged<K?>? onChanged;
  final K? selectedItem;
  final double? width;
  final DropdownSearchFilterFn<T>? filterFn;
  final bool showSearchBox;
  final bool autofocus;
  final DropdownSearchCompareFn<T>? compareFn;

  final String? Function(K?)? validator;
  final bool Function(T)? disabledItemFn;
  final TextEditingController? textEditingController;
  final String? valueProperty;
  final String? labelProperty;
  final String Function(Map<String, dynamic>?)? labelBuilder;
  final FocusNode? focusNode;
  final Key? keyDropdown;
  final T Function(Map<String, dynamic>?)? fromJsonFn;

  CustomDropdown({
    super.key,
    this.enabled = true,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.keyDropdown,
    this.valueProperty,
    this.labelProperty = "label",
    String Function(Map<String, dynamic>?)? labelBuilder,
    this.selectedItem,
    this.width,
    this.filterFn,
    this.showSearchBox = false,
    this.autofocus = false,
    this.focusNode,
    this.compareFn,
    this.validator,
    this.disabledItemFn,
    this.textEditingController,
    this.fromJsonFn,
  })  : itemsMap = buildItemsMap(items, valueProperty),
        labelBuilder = labelBuilder ??
            ((p0) =>
                p0?[labelProperty] == null ? '' : p0![labelProperty] as String);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final showNormal = itemsMap!.length < 500;

    return SizedBox(
      width: width ?? size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          gapH4,
          showNormal ? _buildNormal(context) : _buildPaginated(context),
        ],
      ),
    );
  }

  _buildNormal(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<K>(
        dropdownButtonKey: keyDropdown,
        isExpanded: true,
        autofocus: autofocus,
        focusNode: focusNode,
        decoration: InputDecoration(
          focusColor: const Color(0xFFF1F4F7),
          contentPadding: const EdgeInsets.all(0),
          /*labelText: labelText,
                labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(enabled ? 1 : 0.7),
                    fontWeight: FontWeight.w500),*/
          fillColor: enabled ? Colors.black : const Color(0xFF686A6D),
          hoverColor: Colors.amberAccent,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        hint: Padding(
          padding: EdgeInsets.all(2.0.sp),
          child: Text(
            '$labelText',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        validator: validator,
        items: itemsMap!
            .map((item) => DropdownMenuItem(
                  value: item[valueProperty!] == null
                      ? null
                      : item[valueProperty!] as K,
                  enabled: disabledItemFn == null || fromJsonFn == null
                      ? true
                      : !disabledItemFn!(fromJsonFn!(item)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            labelBuilder!(item),
                            //overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  (disabledItemFn == null || fromJsonFn == null
                                              ? false
                                              : disabledItemFn!(
                                                  fromJsonFn!(item))) ||
                                          !enabled
                                      ? const Color(0xFF686A6D)
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        value: selectedItem == null ||
                itemsMap!
                    .where((element) =>
                        element[valueProperty!] as K == selectedItem)
                    .isEmpty
            ? null
            : selectedItem,
        onChanged: enabled ? onChanged : null,
        buttonStyleData: ButtonStyleData(
          //padding: const EdgeInsets.symmetric(horizontal: 0),
          height: 30.sp,
          width: 200.sp,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  enabled ? const Color(0xFFF1F4F7) : const Color(0xFFDCDEDF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x00000000).withOpacity(0.25),
                  offset: const Offset(
                    0.0,
                    2.0,
                  ),
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                )
              ]),
        ),
        iconStyleData: const IconStyleData(
            iconSize: 36, iconEnabledColor: Color(0xFF51A4D6)),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 400,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 30.sp,
          selectedMenuItemBuilder: (context, child) {
            return Container(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              child: child,
            );
          },
        ),
        dropdownSearchData: showSearchBox
            ? DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50.sp,
                searchInnerWidget: Container(
                  height: 35.sp,
                  padding: EdgeInsets.all(4.sp),
                  child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.sp, horizontal: 5.sp),
                        hintText: 'Buscar $labelText...',
                        hintStyle: TextStyle(fontSize: 14.sp),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      )),
                ),
                searchMatchFn: (item, searchValue) {
                  if (searchValue.isEmpty) {
                    return true;
                  }

                  return labelBuilder!(itemsMap!.firstWhere(
                          (element) => element[valueProperty] == item.value))
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              )
            : null,
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController?.clear();
          }
        },
      ),
    );
  }

  _buildPaginated(BuildContext context) {
    int pageSize = 100;
    var initialSelection = itemsMap!
        .where((element) => element[valueProperty!] as K == selectedItem)
        .firstOrNull;

    return SearchableDropdown<K>.paginated(
      key: key,
      isDialogExpanded: true,
      isEnabled: enabled,
      trailingIcon: const Icon(Icons.arrow_drop_down_sharp,
          size: 36, color: Color(0xFF51A4D6)),
      hasTrailingClearIcon: false,
      searchHintText: 'Buscar $labelText...',
      dialogOffset: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      requestItemCount: pageSize,
      onChanged: enabled ? onChanged : null,
      scrollSensitivity: 1000.0,
      searchBarStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      hintText: Text(
        'Seleccione $labelText',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
      ),
      initialValue: initialSelection == null
          ? null
          : SearchableDropdownMenuItem(
              value: selectedItem,
              label: labelBuilder!(initialSelection),
              child: Text(labelBuilder!(initialSelection),
                  style: const TextStyle(color: Colors.black)),
            ),
      backgroundDecoration: (child) => Card(
        margin: EdgeInsets.zero,
        color: enabled ? const Color(0xFFF1F4F7) : const Color(0xFFDCDEDF),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: child,
        ),
      ),
      paginatedRequest: (int page, String? searchKey) async {
        var allData = itemsMap!;

        if (searchKey != null && searchKey.isNotEmpty) {
          allData = allData
              .where((element) => labelBuilder!(element)
                  .toLowerCase()
                  .contains(searchKey.toLowerCase()))
              .toList();
        }

        return allData
            .skip((page - 1) * pageSize)
            .take(pageSize)
            .map((e) => SearchableDropdownMenuItem(
                value: e[valueProperty!] as K,
                label: labelBuilder!(e),
                child: Text(labelBuilder!(e),
                    style: const TextStyle(color: Colors.black))))
            .toList();
      },
    );
  }
}
