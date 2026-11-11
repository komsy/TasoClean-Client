import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

/// Peach / brown pair used by the quick-service chips and the benefit cards.
const Color _kPeach = Color(0xFFFFE4B3);
const Color _kPeachIcon = Color(0xFFAE681B);

// -----------------------------------------------------------------------------
// Book a Service card
// -----------------------------------------------------------------------------
// Text now stops where the image starts, so it never runs over the photo.
// The fade uses a transparent WHITE (not Colors.transparent, which is
// transparent black and made the grey smudge over the sofa).
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
    return Container(
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
            final imageWidth = constraints.maxWidth * 0.40;
            return Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: imageWidth,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  // Right padding keeps the text clear of the image.
                  padding: EdgeInsets.fromLTRB(
                    MSizes.md,
                    MSizes.md,
                    imageWidth,
                    MSizes.md,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MColors.white,
                        MColors.white,
                        MColors.white.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.6, 1],
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
                              color: MColors.black.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: MSizes.xs),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: MColors.black.withValues(alpha: 0.8),
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

// -----------------------------------------------------------------------------
// Quick services (replaces the hero card on Home)
// -----------------------------------------------------------------------------
// The hero card and the Special Offers card were the same photo with the same
// "Book Now" button. This row gives people a different, faster way in: tap a
// service chip. The last chip ("More") can send them to the Services tab.
class MQuickService {
  const MQuickService({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
}

class MQuickServices extends StatelessWidget {
  const MQuickServices({
    super.key,
    required this.services,
    this.title = 'Book a Service',
    this.onMore,
  });

  final List<MQuickService> services;
  final String title;

  /// When set, a "More" chip is added at the end (e.g. open the Services tab).
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final items = [
      ...services,
      if (onMore != null)
        MQuickService(
          icon: Icons.grid_view_rounded,
          label: 'More',
          onPressed: onMore,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MSectionHeading(title: title, showActionButton: false),
        const SizedBox(height: MSizes.spaceBtwItems / 2),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: MSizes.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return Material(
                color: _kPeach,
                borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
                child: InkWell(
                  onTap: item.onPressed,
                  borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
                  child: SizedBox(
                    width: 92,
                    child: Padding(
                      padding: const EdgeInsets.all(MSizes.sm),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, color: _kPeachIcon, size: 30),
                          const SizedBox(height: MSizes.sm),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: MColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Special offers
// -----------------------------------------------------------------------------
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
          ],
        ),
        const SizedBox(height: MSizes.spaceBtwItems / 2),
        SizedBox(
          // Was 145: a two-line title + subtitle + button could overflow.
          height: 160,
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
                    // Same blue at 0 alpha, so the fade stays blue instead of
                    // passing through grey.
                    Color(0x000B477C),
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

// -----------------------------------------------------------------------------
// Why choose us
// -----------------------------------------------------------------------------
// Cards grow with the text (large font sizes no longer overflow a fixed 112).
// Optional trust line and contact button: pass real values, nothing is made up.
class MWhyChooseUs extends StatelessWidget {
  const MWhyChooseUs({
    super.key,
    this.trustLabel,
    this.onContactPressed,
    this.contactLabel = 'Chat with us',
  });

  /// e.g. your real rating or customer count. Hidden when null.
  final String? trustLabel;

  /// Shows an outlined contact button (e.g. open WhatsApp). Hidden when null.
  final VoidCallback? onContactPressed;
  final String contactLabel;

  @override
  Widget build(BuildContext context) {
    const benefits = [
      (icon: Icons.verified_user, title: 'Verified Experts'),
      (icon: Icons.star, title: 'Quality Assured'),
      (icon: Icons.event_available, title: 'Convenient Booking'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MSectionHeading(
          title: 'Why Choose TasoClean?',
          showActionButton: false,
        ),
        const SizedBox(height: MSizes.spaceBtwItems),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < benefits.length; index++) ...[
                if (index > 0) const SizedBox(width: MSizes.sm),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 112),
                    padding: const EdgeInsets.all(MSizes.sm),
                    decoration: BoxDecoration(
                      color: _kPeach,
                      borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          benefits[index].icon,
                          color: _kPeachIcon,
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
        ),
        if (trustLabel != null) ...[
          const SizedBox(height: MSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: _kPeach, size: 18),
              const SizedBox(width: MSizes.xs),
              Flexible(
                child: Text(
                  trustLabel!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MColors.white.withValues(alpha: 0.85),
                      ),
                ),
              ),
            ],
          ),
        ],
        if (onContactPressed != null) ...[
          const SizedBox(height: MSizes.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onContactPressed,
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(contactLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: MColors.white,
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: MColors.white.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MSizes.buttonRadius),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Shared red call-to-action button (now at least 44 px tall to tap)
// -----------------------------------------------------------------------------
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Align(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MSizes.md),
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: MColors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
