import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RaiseTicketBottomSheet extends StatefulWidget {
  const RaiseTicketBottomSheet({super.key});

  @override
  State<RaiseTicketBottomSheet> createState() => _RaiseTicketBottomSheetState();
}

class _RaiseTicketBottomSheetState extends State<RaiseTicketBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Bookings';
  String _subject = '';
  String _description = '';

  final List<String> _categories = const ['Bookings', 'Scoreboards', 'Payments', 'Account & App'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined, color: Colors.amberAccent, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Raise Support Ticket',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Our support team will get back to you within 2-4 hours.',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 20),

                Text('Category', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: const Color(0xFF2C2C2C),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.04),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _category = val!),
                ),
                const SizedBox(height: 16),

                Text('Subject', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Brief summary of the issue...',
                    hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.04),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a subject' : null,
                  onSaved: (v) => _subject = v ?? '',
                ),
                const SizedBox(height: 16),

                Text('Description', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  maxLines: 4,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Describe your query or issue in detail...',
                    hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.04),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                  onSaved: (v) => _description = v ?? '',
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket created! Support reference #TK-84920'),
                            backgroundColor: Color(0xFF00E676),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Submit Ticket',
                      style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
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
