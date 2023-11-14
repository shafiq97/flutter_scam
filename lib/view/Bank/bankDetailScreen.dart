import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class BankDetailScreen extends StatelessWidget {
  BankDetailScreen(
      {required this.images,
        required this.desc,
        required this.fraudName,
        required this.WalletName,
        required this.bankifsc,
        required this.phoneNumber,
        required this.transactionID});
  final List<dynamic> images;
  final String desc;
  final String fraudName;
  final String WalletName;
  final String bankifsc;
  final String phoneNumber;
  final String transactionID;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: (){Navigator.pop(context);}),
          centerTitle: true,
          title: const Text('Fraud Details'),
        ),
        body: Container(
          height: double.maxFinite,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlideshow(
                  indicatorColor: Colors.blue,
                  onPageChanged: (value) {
                    // debugPrint('Page changed: $value');
                  },
                  //    autoPlayInterval: 3000,
                  //   isLoop: true,
                  children: [
                    for (int i = 0; i < images.length; i++)
                      Image.network(
                        images[i],
                        //  fit: BoxFit.cover,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Fraduster name - ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                fraudName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Bank Name - ",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            WalletName,
                            style:
                            Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: 1.1,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "IFSC Code - ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            bankifsc,
                            style:
                            Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: 1.1,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Descriptions - ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              desc,
                              style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Colors.black.withOpacity(0.5),
                                letterSpacing: 1.1,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Phone Number - ",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            phoneNumber,
                            style:
                            Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: 1.1,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Transaction ID -",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            transactionID,
                            style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: 1.1,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
