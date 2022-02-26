import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bluetooth/bluetooth_bloc.dart';

class RemoteConfigView extends StatefulWidget {
  const RemoteConfigView({Key? key}) : super(key: key);

  @override
  _RemoteConfigViewState createState() => _RemoteConfigViewState();
}

class _RemoteConfigViewState extends State<RemoteConfigView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothBloc, BluetoothState>(
      builder: (context, state) {
        switch (state.value){
          case BluetoothStatus.connected:
            return _selectConfig();
          default: return Text(state.value.toString());
        }
      },
    );
  }

  Widget _getRemoteImage(int number){
    return GestureDetector(
      onTap: (){
        context.read<BluetoothBloc>()
            .add(BluetoothSendData(BluetoothBloc.requestCommand(1, number)));
      },
      child: SvgPicture.asset("assets/svg/remote_$number.svg",width: 150,allowDrawingOutsideViewBox: true,),
    );
  }

  Widget _selectConfig() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10),
      child: Column(
        children: [
          Text("Select the type of your remote controller:",style: Theme.of(context).textTheme.headline6,),
          const SizedBox(height: 20,),
          Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getRemoteImage(1),
                    const SizedBox(width: 10,),
                    _getRemoteImage(2)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("1 buttons",style: Theme.of(context).textTheme.titleLarge,),
                    Text("1 buttons",style: Theme.of(context).textTheme.titleLarge,),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getRemoteImage(3),
                    const SizedBox(width: 10,),
                    _getRemoteImage(4)
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("3 buttons",style: Theme.of(context).textTheme.titleLarge,),
                      Text("4 buttons",style: Theme.of(context).textTheme.titleLarge,),
                    ],
                )
              ]
          )
        ],
      ),
    );
  }
}
