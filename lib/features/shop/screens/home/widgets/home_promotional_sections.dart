import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';


class MBookNowCard extends StatelessWidget {
  const MBookNowCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.image,
    this.onPressed,
  });

  final String title;
  final String description;
  final String buttonText;
  final String image;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final darkmode =THelperFunctions.isDarkMode(context);
    return Container(
      // height: 170,
      decoration: BoxDecoration(
        color: MColors.white,
        borderRadius: BorderRadius.circular(MSizes.cardRadiusSm),
        boxShadow: [
          BoxShadow(
            color: MColors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MSizes.cardRadiusSm),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: constraints.maxWidth * 0.43,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(MSizes.md),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MColors.white,
                        Colors.white,
                        Colors.transparent
                      ],
                      stops: [0, 0.5, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: MColors.black.withValues(alpha:0.8),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: MSizes.xs),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: MColors.black.withValues(alpha:0.8),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: MSizes.sm),
                      _MCallToActionButton(
                        text: buttonText,
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MSpecialOffer {
  const MSpecialOffer({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.image,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final String image;
  final VoidCallback? onPressed;
}

class MHomeSpecialOffers extends StatefulWidget {
  const MHomeSpecialOffers({
    super.key,
    required this.offers,
    this.onSeeAll,
  }) : assert(offers.length > 0);

  final List<MSpecialOffer> offers;
  final VoidCallback? onSeeAll;

  @override
  State<MHomeSpecialOffers> createState() => _MHomeSpecialOffersState();
}

class _MHomeSpecialOffersState extends State<MHomeSpecialOffers> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MSectionHeading(
                title: 'Special Offers',
                showActionButton: false,
              ),
            ),
            // TextButton(
            //   onPressed: widget.onSeeAll,
            //   child: const Row(
            //     children: [
            //       Text('See all'),
            //       SizedBox(width: MSizes.xs),
            //       Icon(Icons.arrow_forward, size: MSizes.iconSm),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: MSizes.spaceBtwItems/2),
        SizedBox(
          height: 145,
          child: PageView.builder(
            itemCount: widget.offers.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              return MSpecialOfferCard(
                title: offer.title,
                subtitle: offer.subtitle,
                buttonText: offer.buttonText,
                image: offer.image,
                onPressed: offer.onPressed,
              );
            },
          ),
        ),
        const SizedBox(height: MSizes.spaceBtwItems),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.offers.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: index == _currentPage ? 10 : 8,
              height: index == _currentPage ? 10 : 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: index == _currentPage ? MColors.primary : MColors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MSpecialOfferCard extends StatelessWidget {
  const MSpecialOfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.image,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final String image;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MColors.primary,
        borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: MColors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xF20B477C),
                    Color(0xD90B477C),
                    Colors.transparent,
                  ],
                  stops: [0, 0.4, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(MSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.55,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: MColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: MSizes.xs),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: MColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: MSizes.md),
                  _MCallToActionButton(
                    text: buttonText,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MWhyChooseUs extends StatelessWidget {
  const MWhyChooseUs({super.key});

  @override
  Widget build(BuildContext context) {
    const benefits = [
      (icon: Icons.verified_user, title: 'Verified Experts'),
      (icon: Icons.star, title: 'Quality Assured'),
      (icon: Icons.event_available, title: 'Convenient Booking'),
      // (icon: Icons.thumb_up, title: 'Great Value'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MSectionHeading(
          title: 'Why Choose TasoClean?',
          showActionButton: false,
        ),
        const SizedBox(height: MSizes.spaceBtwItems),
        Row(
          children: [
            for (var index = 0; index < benefits.length; index++) ...[
              if (index > 0) const SizedBox(width: MSizes.sm),
              Expanded(
                child: Container(
                  height: 112,
                  padding: const EdgeInsets.all(MSizes.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4B3),
                    borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        benefits[index].icon,
                        color: const Color(0xFFAE681B),
                        size: 30,
                      ),
                      const SizedBox(height: MSizes.sm),
                      Text(
                        benefits[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: MColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MCallToActionButton extends StatelessWidget {
  const _MCallToActionButton({
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MColors.error,
      borderRadius: BorderRadius.circular(MSizes.buttonRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(MSizes.buttonRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MSizes.md,
            vertical: MSizes.sm,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: MColors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
