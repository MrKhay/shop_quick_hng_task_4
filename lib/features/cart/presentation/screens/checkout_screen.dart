import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_quick/features/features.dart';

import '../../../../shop_quick.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<Order> orders;
  const CheckoutScreen({super.key, required this.orders});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // we have initialized active step to 0 so that
  // our stepper widget will start from first step
  int _activeCurrentStep = 0;
  bool isLoading = false;
  bool hasPaid = false;
  late ConfettiController controller = ConfettiController();
  late TextEditingController fullName = TextEditingController();
  late TextEditingController number = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController pass = TextEditingController();
  late TextEditingController address = TextEditingController();
  late TextEditingController city = TextEditingController();
  late TextEditingController cardName = TextEditingController();
  late TextEditingController cardNumber = TextEditingController();
  late TextEditingController cardExpireDate = TextEditingController();
  late TextEditingController cardCVV = TextEditingController();
  late TextEditingController state = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ConfettiController();
    fullName = TextEditingController();
    number = TextEditingController();
    email = TextEditingController();
    pass = TextEditingController();
    address = TextEditingController();
    city = TextEditingController();
    cardName = TextEditingController();
    cardNumber = TextEditingController();
    cardExpireDate = TextEditingController();
    cardCVV = TextEditingController();
    state = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    fullName.dispose();
    number.dispose();
    email.dispose();
    pass.dispose();
    address.dispose();
    city.dispose();
    cardName.dispose();
    cardNumber.dispose();
    cardExpireDate.dispose();
    cardCVV.dispose();
    state.dispose();
    super.dispose();
  }

  // Here we have created list of steps
  // that are required to complete the form
  List<Step> stepList() => [
        Step(
            state: _activeCurrentStep <= 1
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 0,
            title: const Text('Address'),
            content: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: fullName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                  ),
                  const SizedBox(
                    height: kGap_1,
                  ),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: kGap_1,
                  ),
                  TextField(
                    controller: number,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone number',
                    ),
                  ),
                  const SizedBox(
                    height: kGap_1,
                  ),
                  TextField(
                    controller: address,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'House Address',
                    ),
                  ),
                  const SizedBox(
                    height: kGap_1,
                  ),
                  TextField(
                    controller: state,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'State',
                    ),
                  ),
                  const SizedBox(
                    height: kGap_1,
                  ),
                  TextField(
                    controller: city,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                    ),
                  ),
                ],
              ),
            )),

        // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 1,
            title: const Text('Payment'),
            content: Container(
                padding: const EdgeInsets.all(kGap_0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      kPaymentOption,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: kGap_2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                            child: _paymentOptionWidget(
                          Icons.credit_card,
                          kBankCard,
                          true,
                          onTap: () {},
                        )),
                        Flexible(
                            child: _paymentOptionWidget(
                          Icons.business,
                          kBankTransfer,
                          false,
                          onTap: () {
                            context.showSnackBar(kComingSoon);
                          },
                        )),
                        Flexible(
                            child: _paymentOptionWidget(
                          Icons.currency_bitcoin_sharp,
                          kBitcoin,
                          false,
                          onTap: () {
                            context.showSnackBar(kComingSoon);
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: kGap_3),

                    // card hold name
                    TextField(
                      controller: cardName,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder Name',
                      ),
                    ),
                    const SizedBox(
                      height: kGap_2,
                    ),

                    // card number
                    TextField(
                      controller: cardNumber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Number',
                      ),
                    ),
                    const SizedBox(
                      height: kGap_2,
                    ),

                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: cardExpireDate,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Expire Date',
                                hintText: '05/70'),
                          ),
                        ),
                        const SizedBox(width: kGap_2),
                        Flexible(
                          child: TextField(
                            controller: cardCVV,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Cvv',
                                hintText: '000'),
                          ),
                        ),
                      ],
                    )
                  ],
                ))), // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: const Text('Confirm'),
            content: SizedBox(
                width: context.screenSize.width,
                height: context.screenSize.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: controller,
                        blastDirection: -pi / 2, // radial value - RIGHT
                        particleDrag: 0.05, // apply drag to the confetti
                        emissionFrequency: 0.05, // how often it should emit
                        numberOfParticles: 20, // number of particles to emit
                        gravity: 0.02, // gravity - or fall speed
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink
                        ], // manually specify the colors to be used
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      ),
                    ),
                    hasPaid
                        ? _orderConfirmation()
                        : _cartSummary(
                            widget.orders), //CENTER RIGHT -- Emit left
                  ],
                )))
      ];

  Column _paymentOptionWidget(IconData icon, String title, bool active,
      {void Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: kGap_1),
            padding: const EdgeInsets.symmetric(
                horizontal: kGap_1, vertical: kGap_2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kGap_1),
              color: active
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant,
            ),
            child: Icon(
              icon,
              color: active
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: kGap_0),
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: active
                ? context.colorScheme.primary
                : context.colorScheme.onSurface,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String? _verifyAddressStepper() {
    if (fullName.text.isEmpty) {
      return 'Enter full name';
    }
    if (email.text.isEmpty) {
      return 'Enter email address';
    }
    if (number.text.isEmpty) {
      return 'Enter phone number';
    }
    if (address.text.isEmpty) {
      return 'Enter address';
    }
    if (state.text.isEmpty) {
      return 'Enter state name';
    }
    if (city.text.isEmpty) {
      return 'Enter city name';
    }
    return null;
  }

  String? _verifyPaymentStepper() {
    if (cardName.text.isEmpty) {
      return 'Enter card holder name';
    }
    if (cardNumber.text.isEmpty) {
      return 'Enter card number';
    }
    if (cardExpireDate.text.isEmpty) {
      return 'Enter card expire date';
    }
    if (cardCVV.text.isEmpty) {
      return 'Enter card cvv';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context: context,
          title: kCheckout,
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(kGap_0), child: SizedBox())),
      // Here we have initialized the stepper widget
      body: Stepper(
        controlsBuilder: (context, details) {
          if (_activeCurrentStep == 2) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kGap_1, vertical: kGap_3),
            child: Row(
              children: [
                // cancle
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(kGap_2)),
                  ),
                  onPressed: () {
                    details.onStepCancel?.call();
                  },
                  child: const Text(kCancel),
                ),

                const SizedBox(width: kGap_2),
                // next
                MaterialButton(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(kGap_2)),
                    color: context.colorScheme.primary,
                    onPressed: () {
                      details.onStepContinue?.call();
                    },
                    child: Text(
                      kNext,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: context.colorScheme.onPrimary),
                    )),
              ],
            ),
          );
        },
        elevation: 1,

        type: StepperType.horizontal,
        currentStep: _activeCurrentStep,
        steps: stepList(),

        // onStepContinue takes us to the next step
        onStepContinue: () {
          if (_activeCurrentStep == 0) {
            var responce = _verifyAddressStepper();

            if (responce != null) {
              context.showSnackBar(responce, type: SnackBarType.error);
              return;
            }
          }
          if (_activeCurrentStep == 1) {
            var responce = _verifyPaymentStepper();

            if (responce != null) {
              context.showSnackBar(responce, type: SnackBarType.error);
              return;
            }
          }
          if (_activeCurrentStep < (stepList().length - 1)) {
            setState(() {
              _activeCurrentStep += 1;
            });
          }
        },

        // onStepCancel takes us to the previous step
        onStepCancel: () {
          if (_activeCurrentStep == 0) {
            return;
          }

          setState(() {
            _activeCurrentStep -= 1;
          });
        },

        // onStepTap allows to directly click on the particular step we want
        onStepTapped: (int index) {},
      ),
    );
  }

  Widget _orderConfirmation() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.check)),
          const SizedBox(height: kGap_2),
          Text(
            kThankForShoppingWithUs,
            style: GoogleFonts.lora(
              textStyle: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: kGap_1),
          Text(
            'Order confirmation has been sent to \n ${email.text}',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: kGap_3),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: context.colorScheme.primary),
            onPressed: () {
              /// clear order
              ref.read(ordersDataNotifierProvider.notifier).clearOrders();

              /// navigate back home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ShopFast()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text(
              kContinueShopping,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cartSummary(List<Order> orders) {
    var navigator = Navigator.of(context);
    var deliveryCost = orders.length * 0.5;
    // sum up price of all products
    final double totalPrice = orders.totalPrice();
    final String price = r'$' + totalPrice.toStringAsFixed(2);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(kGap_2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kGap_1),
        border: Border.all(color: context.colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Cart sumary
          Text(
            kCartSummary,
            style: GoogleFonts.lora(
              textStyle: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: kGap_2),

          // prices
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGap_4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kSubTotal,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.outline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      price,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kGap_2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kDelivery,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.outline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      r'$' + deliveryCost.toString(),
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: kGap_2),
          const Divider(),
          const SizedBox(height: kGap_1),

          // check out
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Spacer(),
              // price
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Total amount
                  Text(
                    kTotalAmount,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: kGap_0),

                  /// Price
                  Text(
                    price,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: kGap_1),
          const Divider(),
          const SizedBox(height: kGap_1),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // cancle btn
              Visibility(
                visible: isLoading == false,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _activeCurrentStep--;
                    });
                  },
                  child: Text(
                    kCancel,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: kGap_3),
              // pay now
              MaterialButton(
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(kGap_1)),
                color: context.colorScheme.primary,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 700));
                  setState(() {
                    isLoading = false;
                    hasPaid = true;
                  });

                  // add order to history
                  ref
                      .read(orderHistoryDataNotifierProvider.notifier)
                      .addNewOrder(orders);

                  /// clear order
                  ref.read(ordersDataNotifierProvider.notifier).clearOrders();

                  // start confetti
                  controller.play();
                  await Future.delayed(const Duration(milliseconds: 20000));
                  // stop confetti
                  controller.stop();
                },
                child: isLoading
                    ? Row(
                        children: [
                          Text(
                            kPaynow,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: kGap_3),
                          SizedBox(
                            height: kGap_2,
                            width: kGap_2,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        kPaynow,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
