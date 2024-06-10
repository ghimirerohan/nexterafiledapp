
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_events.dart';
import '../bloc/login_bloc/login_states.dart';



class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {


  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginBloc>().add(EmailUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(PasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  _popBackExitCallBack(){
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Exit"),
          content: const Text("Sure To Exit The App ?",style:
          TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value){
        if(value){
          _popBackExitCallBack();
        }
      },
      child: Scaffold(
        body: BlocListener<LoginBloc , MyFormState>(
          listener: (context, state){
            if (state.status.isSubmissionSuccess) {
              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // showDialog<void>(
              //   context: context,
              //   builder: (_) => const SuccessDialog(),
              // );
            }
            if (state.status.isSubmissionInProgress) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Submitting...')),
                );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 45,
                ),
                Container(
                  padding: const EdgeInsets.all(
                      6.0), // Adjust the padding as per your requirement
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the border radius as per your requirement
                    color: Colors
                        .white, // Adjust the background color as per your requirement
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 66,
                    width: 250,
                  ),
                ),

                const SizedBox(
                  height: 81,
                ),
                const Text(
                  'Collector Portal',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                const Text(
                  'Please Login To Your Account',
                  style: TextStyle(fontSize: 18, color: Colors.grey , fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 33,
                ),
                EmailInput(focusNode: _emailFocusNode),
                PasswordInput(focusNode: _passwordFocusNode),
                const SizedBox(
                  height: 42,
                ),
                const SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LoginBloc, MyFormState>(
        builder: (context, state){

          return  Padding(
            padding: const EdgeInsets.only(left: 21.0 , right: 21,top: 12, bottom: 12),
            child: SizedBox(
              width: 333,
              child: TextFormField(
                initialValue: state.email.value,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Username',
                  helperText: 'A complete, valid Username',
                  errorText: state.email.invalid ? 'Please ensure the username entered is valid'
                      : null,
                  suffixIcon: const Icon(
                    Icons.person,
                    size: 25,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<LoginBloc>().add(EmailChanged(email: value));
                },
                textInputAction: TextInputAction.next,
              ),
            ),
          );
        }
    );
  }
}


class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, MyFormState>(
      builder: (context, state) {

        return  Padding(
          padding: const EdgeInsets.only(left: 21.0 , right: 21,top: 12, bottom: 12),
          child: SizedBox(
            width: 333,
            child: TextFormField(
              initialValue: state.password.value,
              onChanged: (value) {
                context.read<LoginBloc>().add(PasswordChanged(password: value));
              },
              textInputAction: TextInputAction.done,
              focusNode: focusNode,
              obscureText: true,
              decoration: InputDecoration(
                helperText:
                '''Password should be at least 8 characters with at least one letter and number''',
                helperMaxLines: 2,
                labelText: 'Password',
                errorMaxLines: 2,
                errorText: state.password.invalid
                    ? '''Password must be at least 8 characters and contain at least one letter and number'''
                    : null,
                suffixIcon:  const Icon(
                  Icons.remove_red_eye,
                  size: 25,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, MyFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return  state.status.isSubmissionInProgress ? const CircularProgressIndicator() :
        SizedBox(
          height: 45,width: 222,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF4485c5)),
            ),
            onPressed: state.status.isValidated
                ? () => context.read<LoginBloc>().add(FormSubmitted(context: context))
                : null,
            child:  const Text('Login',style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
          ),
        );
      },
    );
  }
}



class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Form Submitted Successfully!',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}