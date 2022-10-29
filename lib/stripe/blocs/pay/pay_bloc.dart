import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/credit_card_custom.dart';

part 'pay_event.dart';
part 'pay_state.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc() : super(const PayState()) {
    on<OnSelectCardEvent>((event, emit) => emit( state.copyWith( isActiveCard:  true, card: event.card ) ));
    on<OnDeactiveCard>((event, emit) => emit( state.copyWith( isActiveCard: false ) ));
  }
  // @override
  // Stream<PayState> mapEventToState( PayEvent event) async* {
  //   if ( event is OnSelectCardEvent ) {
  //     yield state.copyWith( isActiveCard: true, card: event.card );
  //   } else if ( event is OnDeactiveCard ) {
  //     yield state.copyWith( isActiveCard: false );
  //   }
  // }
}
