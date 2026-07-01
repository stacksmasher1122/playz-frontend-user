import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'trainer_form_fields.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kSurface = Color(0xFF0E0E0E);

class PricingPackagesSection extends StatefulWidget {
  PricingPackagesSection({super.key});

  @override
  State<PricingPackagesSection> createState() => _PricingPackagesSectionState();
}

class _PricingPackagesSectionState extends State<PricingPackagesSection> {
  final Map<String, bool> enabled = {
    'Trial': true,
    'Monthly': true,
    '3 Months': false,
    '6 Months': false,
    '1 Year': false,
  };

  final Map<String, TextEditingController> priceControllers = {
    'Trial': TextEditingController(),
    'Monthly': TextEditingController(),
    '3 Months': TextEditingController(),
    '6 Months': TextEditingController(),
    '1 Year': TextEditingController(),
  };

  final Map<String, List<String>> perks = {
    'Trial': [],
    'Monthly': [],
    '3 Months': [],
    '6 Months': [],
    '1 Year': [],
  };

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        StepHeader(step: 6, title: 'Pricing & Packages'),

        SizedBox(height: 16),
        PerksSection(),
        SizedBox(height: 16),
        ...enabled.keys.map((key) {
          return PackagePricingCard(
            title: key,
            enabled: enabled[key]!,
            priceController: priceControllers[key]!,
            perks: perks[key]!,
            onToggle: (v) => setState(() => enabled[key] = v),
            onAddPerk: (perk) => setState(() => perks[key]!.add(perk)),
            onRemovePerk: (perk) => setState(() => perks[key]!.remove(perk)),
          );
        }),

        SizedBox(height: 12),

        Text(
          'Note: Final pricing is subject to platform review.',
          style: TextStyle(color: kMuted, fontSize: 12),
        ),
      ],
    );
  }
}

class PackagePricingCard extends StatelessWidget {
  final String title;
  final bool enabled;
  final TextEditingController priceController;
  final List<String> perks;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onAddPerk;
  final ValueChanged<String> onRemovePerk;

  PackagePricingCard({
    super.key,
    required this.title,
    required this.enabled,
    required this.priceController,
    required this.perks,
    required this.onToggle,
    required this.onAddPerk,
    required this.onRemovePerk,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: enabled ? kGreen : Colors.transparent,
          width: ResponsiveHelper.w(1.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + CHECK
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(value: enabled, activeThumbColor: kGreen, onChanged: onToggle),
            ],
          ),

          if (enabled) ...[
            SizedBox(height: 12),

            /// PRICE INPUT
            TrainerInputField(
              label: 'Price (₹)',
              hint: 'e.g. 2000',
              controller: priceController,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 12),

            /// PERKS
            Text(
              'Included Perks',
              style: TextStyle(
                color: kMuted,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: perks
                  .map(
                    (p) => PerkChip(text: p, onRemove: () => onRemovePerk(p)),
                  )
                  .toList(),
            ),

            SizedBox(height: 8),

            AddPerkField(onAdd: onAddPerk),
          ],
        ],
      ),
    );
  }
}

class AddPerkField extends StatefulWidget {
  final ValueChanged<String> onAdd;
  AddPerkField({super.key, required this.onAdd});

  @override
  State<AddPerkField> createState() => _AddPerkFieldState();
}

class _AddPerkFieldState extends State<AddPerkField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add a perk (e.g. Video Analysis)',
              hintStyle: TextStyle(color: kMuted),
              filled: true,
              fillColor: kSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add_circle, color: kGreen),
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              widget.onAdd(controller.text.trim());
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}

class PerksSection extends StatefulWidget {
  PerksSection({super.key});

  @override
  State<PerksSection> createState() => _PerksSectionState();
}

class _PerksSectionState extends State<PerksSection> {
  final Map<String, List<String>> packagePerks = {
    'Trial': [],
    '1 Month': [],
    '3 Months': [],
    '6 Months': [],
    '1 Year': [],
  };

  final Set<String> suggestedPerks = {
    'Kit Provided',
    'Video Analysis',
    'Fitness Tracking',
    'Match Practice',
    'Diet Plan',
    'Performance Report',
  };

  String selectedPackage = 'Trial';
  final TextEditingController perkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final perks = packagePerks[selectedPackage]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),

        /// TITLE
        Text(
          'Package Perks',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(15),
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 8),

        /// ACTIVE PERKS (CHIPS)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: perks.map((perk) {
            return PerkChip(
              text: perk,
              onRemove: () {
                setState(() => perks.remove(perk));
              },
            );
          }).toList(),
        ),

        SizedBox(height: 12),

        /// ADD PERK INPUT
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: perkController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a perk (e.g. Injury Rehab)',
                  hintStyle: TextStyle(color: kMuted.withValues(alpha: 0.6)),
                  filled: true,
                  fillColor: kCard,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                    borderSide: BorderSide(color: kGreen),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add_circle, color: kGreen),
              onPressed: () {
                final text = perkController.text.trim();
                if (text.isEmpty) return;

                setState(() {
                  if (!perks.contains(text)) {
                    perks.add(text);
                    suggestedPerks.add(text);
                  }
                  perkController.clear();
                });
              },
            ),
          ],
        ),

        SizedBox(height: 12),

        /// SUGGESTED PERKS
        Text(
          'Suggested',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(13),
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 6),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestedPerks.map((perk) {
            final isAdded = perks.contains(perk);
            return SuggestionChip(
              text: perk,
              active: isAdded,
              onTap: () {
                if (!isAdded) {
                  setState(() => perks.add(perk));
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PerkChip extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  PerkChip({super.key, required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
      decoration: BoxDecoration(
        color: kGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: kGreen),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: kGreen),
          ),
        ],
      ),
    );
  }
}

class SuggestionChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  SuggestionChip({
    super.key,
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
        decoration: BoxDecoration(
          color: active ? kGreen.withValues(alpha: 0.2) : kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          border: Border.all(color: active ? kGreen : Colors.grey.shade800),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? kGreen : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
