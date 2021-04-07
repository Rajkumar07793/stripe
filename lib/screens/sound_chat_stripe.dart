import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';

import 'home.dart';

class ShopPay extends StatefulWidget {
  @override
  _ShopPayState createState() => _ShopPayState();
}
class _ShopPayState extends State<ShopPay> {
  String radioItem = '';
  var cart;
  String _paymentMethodId;
  String _errorMessage = "";
  final _stripePayment = FlutterStripePayment();
  @override
  void initState() {
    super.initState();
    _stripePayment.setStripeSettings(
        "pk_test_51IcrCaSGgp78HSWo97V4Z9xHkZ8aYfbJJwA588p5XxmMGQLbESkrNASsxZ5jZlpqUd7xluY1DDkwaJrsarf5XSJt00jZ0YKVIm");
    _stripePayment.onCancel = () {
      print("the payment form was cancelled");
    };
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // cart= context.watch<ProductModellist>();
    return SafeArea(
        child: Stack(children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
            },),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFFE18D13),
              backwardsCompatibility: true,
            ),
            bottomNavigationBar: Container(
              height: height*0.0731,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      // createOrderState(context);///todo: api for create order
                      // Provider.of<ProductModellist>(context, listen: false).removeAll();//clear provider data
                      // Navigator.of(context)
                      //     .pushReplacement(
                      //     MaterialPageRoute(builder: (context) => ShopSccess()));
                    },
                    child: Text(
                      " Total Amount Pay: 199",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 50,width: width,
                  child: Row(
                    children: [
                      Image.asset("assets/visa.png",),
                      SizedBox(width: 10,),
                      Image.asset("assets/mastercard.png",),
                      SizedBox(width: 10,),
                      Image.asset("assets/discover.png",),
                      SizedBox(width: 10,),
                      Image.asset("assets/paypal.png",),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Payment Method",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF535353),
                                    fontSize: 20,
                                    fontFamily: 'Montserrat1',
                                    fontWeight: FontWeight.bold)),
                          ),

                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('PayPal'),
                            value: 'Item 1',
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                                // pay();

                              });
                            },
                          ),

                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('Credit Card (Stripe)'),
                            value: 'Item 2',
                            onChanged: (val) {
                              setState(() {
                                _stripePayment.setStripeSettings(
                                    "pk_test_aSaULNS8cJU6Tvo20VAXy6rp");
                                radioItem = val;
                                Strippay();
                              });
                            },
                          ),
                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('Cash On Delivery'),
                            value: 'Item 3',
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            },
                          ),
                        ]
                    )
                )
              ],
            ),
          )
        ]
        )
    );
  }

  Strippay() async {
    var paymentResponse = await _stripePayment.addPaymentMethod();
    setState(() {
      if (paymentResponse.status ==
          PaymentResponseStatus.succeeded) {
        print(paymentResponse.paymentMethodId);
        // Toast.show(paymentResponse.paymentMethodId, context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        _paymentMethodId = paymentResponse.paymentMethodId;
      } else {
        _errorMessage = paymentResponse.errorMessage;
        print("error: "+_errorMessage);
      }
    });
  }

}