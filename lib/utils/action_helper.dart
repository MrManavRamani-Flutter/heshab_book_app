import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_translations.dart';

class ActionHelper {
  /// Opens phone dialer directly (works 100% offline)
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanNumber.isEmpty) return false;
    final Uri uri = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Opens WhatsApp with pre-drafted payment reminder message (works offline via app intent)
  static Future<bool> sendWhatsAppReminder({
    required String phoneNumber,
    required String partyName,
    required double pendingAmount,
    required String lang,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return false;

    // Normalize phone number for India (+91) if 10 digits
    final targetPhone = cleanPhone.length == 10 ? '91$cleanPhone' : cleanPhone;
    final formattedAmount = AppTranslations.formatCurrency(pendingAmount, lang);

    String message;
    if (lang == 'gu') {
      message = 'નમસ્તે $partyName જી,\n'
          'આપની બાકી રકમ ₹$formattedAmount છે.\n'
          'કૃપા કરીને વહેલી તકે ચુકવણી કરવા વિનંતી.\n'
          '— હિસાબ બુક (Heshab Book)';
    } else if (lang == 'hi') {
      message = 'नमस्ते $partyName जी,\n'
          'आपकी कुल बकाया राशि ₹$formattedAmount है।\n'
          'कृपया जल्द से जल्द भुगतान करने का कष्ट करें।\n'
          '— हिसाब बुक (Heshab Book)';
    } else {
      message = 'Hello $partyName,\n'
          'Your outstanding payment is ₹$formattedAmount.\n'
          'Kindly arrange the payment at your earliest convenience.\n'
          '— Heshab Book';
    }

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$targetPhone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
